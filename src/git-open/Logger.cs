using System;

namespace git_open
{
    public class Logger
    {
		private static bool _IsVerbose = false;
		
		public static void Verbose(string msg)
		{
			if(_IsVerbose)
			{
				Console.WriteLine(msg);
			}
		}
		
	}
}
