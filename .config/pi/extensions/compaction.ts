import { uuidv7 } from "@earendil-works/pi-ai";
import {
  convertToLlm,
  serializeConversation,
  type ExtensionAPI,
} from "@earendil-works/pi-coding-agent";

const PROVIDER = "openai-codex";
const MODEL = "gpt-5.6-terra";

export default function (pi: ExtensionAPI) {
  pi.on("session_before_compact", async (event, ctx) => {
    const { preparation, customInstructions, signal } = event;
    const model = ctx.modelRegistry.find(PROVIDER, MODEL);

    if (!model) {
      ctx.ui.notify(`${PROVIDER}/${MODEL} unavailable; using default compaction`, "warning");
      return;
    }

    const messages = [
      ...preparation.messagesToSummarize,
      ...preparation.turnPrefixMessages,
    ];
    const conversation = serializeConversation(convertToLlm(messages));
    const previousSummary = preparation.previousSummary
      ? `\n\nPrevious summary to update:\n${preparation.previousSummary}`
      : "";
    const additionalFocus = customInstructions
      ? `\n\nAdditional focus requested by the user:\n${customInstructions}`
      : "";

    const modifiedFiles = [
      ...new Set([
        ...preparation.fileOps.written,
        ...preparation.fileOps.edited,
      ]),
    ].sort();
    const modified = new Set(modifiedFiles);
    const readFiles = [...preparation.fileOps.read]
      .filter((path) => !modified.has(path))
      .sort();

    const prompt = `Create a structured summary of this coding-agent conversation.${previousSummary}${additionalFocus}

Use this exact format:

## Goal
[What the user is trying to accomplish]

## Constraints & Preferences
- [Requirements and preferences]

## Progress
### Done
- [x] [Completed work]

### In Progress
- [ ] [Current work]

### Blocked
- [Blockers, or "(none)"]

## Key Decisions
- **[Decision]**: [Rationale]

## Next Steps
1. [What should happen next]

## Critical Context
- [Details needed to continue]

Preserve exact file paths, function names, commands, errors, decisions, and unresolved questions. Be concise but do not omit information needed to resume the work. Do not continue the conversation.

<conversation>
${conversation}
</conversation>`;

    try {
      const response = await ctx.modelRegistry.complete(
        model,
        {
          systemPrompt:
            "You summarize coding-agent context. Output only the requested structured summary.",
          messages: [
            {
              role: "user",
              content: [{ type: "text", text: prompt }],
              timestamp: Date.now(),
            },
          ],
        },
        {
          maxTokens: 8192,
          reasoningEffort: "low",
          signal,
          cacheRetention: "none",
          sessionId: uuidv7(),
        },
      );

      let summary = response.content
        .filter((part): part is { type: "text"; text: string } => part.type === "text")
        .map((part) => part.text)
        .join("\n")
        .trim();

      if (!summary) {
        if (!signal.aborted) ctx.ui.notify("Terra returned an empty summary; using default compaction", "warning");
        return;
      }

      summary += `\n\n<read-files>\n${readFiles.join("\n")}\n</read-files>`;
      summary += `\n\n<modified-files>\n${modifiedFiles.join("\n")}\n</modified-files>`;

      return {
        compaction: {
          summary,
          firstKeptEntryId: preparation.firstKeptEntryId,
          tokensBefore: preparation.tokensBefore,
          usage: response.usage,
          details: { readFiles, modifiedFiles },
        },
      };
    } catch (error) {
      if (!signal.aborted) {
        const message = error instanceof Error ? error.message : String(error);
        ctx.ui.notify(`Terra compaction failed: ${message}; using default compaction`, "warning");
      }
      return;
    }
  });
}
