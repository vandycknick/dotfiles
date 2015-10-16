#if !DNXCORE50
using System;
using LibGit2Sharp;
using System.IO;

namespace git_open
{
    public class Git
    {
        public static Repository GetRepository(string directory)
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
                    Logger.Verbose(ex.Message);
                }

                curDir = curDir.Parent;
            }

            if (curDir == null)
            {
                throw new RepositoryNotFoundException("Not a git repository (or any of the parent directories): .git");
            }

            return gitRepo;
        }
    }
}
#endif