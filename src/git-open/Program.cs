using System;

#if !DNXCORE50
using System.IO;
using System.Diagnostics;
using LibGit2Sharp;
#endif

namespace git_open
{
    public class Program
    {
        public static int Main(string[] args)
        {
#if DNXCORE50
            Console.WriteLine($"Program not working with dotnet coreclr!");
            return 1;
#endif

#if !DNXCORE50
            var curDir = Directory.GetCurrentDirectory();
            try
            {
                using (var repo = Git.GetRepository(curDir))
                {
                    //assume origin if not provided
                    var remote = "origin";
                    var remoteKey = $"remote.{remote}.url";
                    var config = repo.Config;
                    var gitUrl = config.Get<string>(remoteKey).Value;

                    Process.Start(gitUrl);
                }
            }
            catch (RepositoryNotFoundException ex)
            {
                Console.WriteLine(ex.Message);
            }
            
            return 0;
#endif
        }
    }
}
