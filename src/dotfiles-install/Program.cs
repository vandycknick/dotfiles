using System;
using System.IO;

#if DNX451
using LibGit2Sharp;
#endif

namespace Dotfiles.Install
{
    public class Program
    {
        public void Main(string[] args)
        {
            string currentDir = Directory.GetCurrentDirectory();

#if DNX451
            try
            {
                using (var repo = new Repository(currentDir))
                {
                    Console.WriteLine(repo.Config.Get<string>("remote.origin.url").Value);
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
            }
#endif

            Console.WriteLine("Current Directory: {0}", currentDir);
            Console.ReadLine();
        }
    }
}
