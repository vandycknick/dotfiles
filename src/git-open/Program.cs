using System;
using System.Diagnostics;
using System.IO;
using System.Reflection;
using System.Collections.Generic;
using LibGit2Sharp;
using NDesk.Options;

namespace gitopen
{
	public class Program
	{
		private OptionSet options;
		private bool help = false;
		private bool verbose = false;

		public static void Main (string[] args)
		{
			var program = new Program();
			program.Run(args);
		}

		public Program ()
		{
			options = new OptionSet() {
				{ "v|verbose", "show verbose logging", v => verbose = v != null },
				{ "h|help",  "show help information", v => help = v != null },
			};

			if (help) {
				ShowHelp(options);
				return;
			}
		}

		public void Run(string[] args) {

			List<string> extra;
			try {
				extra = options.Parse(args);
			}
			catch (OptionException e) {
				Console.Write ("git-open: ");
				Console.WriteLine (e.Message);
				Console.WriteLine ("Try `greet --help' for more information.");
				return;
			}

			if (help) {
				ShowHelp(options);
				return;
			}

			LogVerbose($"Assembly version: {GetInformationalVersion()}");

			var curDir = Directory.GetCurrentDirectory();

			try
			{
				using (var repo = GetGitRepository(curDir))
				{
					//assume origin if not provided
					var remote = "origin";
					var remoteKey = $"remote.{remote}.url";
					var config = repo.Config;
					var gitUrl = config.Get<string>(remoteKey).Value;


					Console.WriteLine($"Found giturl: {gitUrl}");
					Process.Start(gitUrl);
				}
			}
			catch (LibGit2Sharp.RepositoryNotFoundException ex)
			{
				Console.WriteLine(ex.Message);
			}
		}

		public Repository GetGitRepository(string directory)
		{
			var dirInfo = new DirectoryInfo(directory);
			var curDir = dirInfo;
			Repository gitRepo = null;

			while (curDir != null)
			{
				try
				{
					gitRepo = new Repository(curDir.FullName);
					break;
				}
				catch (Exception ex)
				{
					if (gitRepo != null) gitRepo.Dispose();
					LogVerbose(ex.Message);
				}

				curDir = curDir.Parent;
			}

			if (curDir == null)
			{
				throw new RepositoryNotFoundException("Not a git repository (or any of the parent directories): .git");
			}

			return gitRepo;
		}

		public void ShowHelp(OptionSet p) {
			Console.WriteLine ("Usage: git-open [OPTIONS]+ message");
			Console.WriteLine ("Open the github website for the current git project.");
			Console.WriteLine ("Looks in the parent folder until root is reached.");
			Console.WriteLine ();
			Console.WriteLine ("Options:");
			p.WriteOptionDescriptions (Console.Out);
		}

		private void LogVerbose(string msg) {
			if (verbose) {
				Console.WriteLine(msg);
			}
		}

		private string GetInformationalVersion()
		{
			var assembly = typeof(Program).GetTypeInfo().Assembly;
			var attributes = assembly.GetCustomAttributes(typeof(AssemblyInformationalVersionAttribute)) as AssemblyInformationalVersionAttribute[];

			var versionAttribute = attributes.Length == 0 ? 
				assembly.GetName().Version.ToString() :
				attributes[0].InformationalVersion;

			return versionAttribute;
		}
	}
}
