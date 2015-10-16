using System;
using System.IO;

namespace Dotfiles.Install
{
    public class Program
    {
        public void Main(string[] args)
        {
            string currentDir = Directory.GetCurrentDirectory();

            Console.WriteLine("Current Directory: {0}", currentDir);
            Console.ReadLine();
        }
    }
}
