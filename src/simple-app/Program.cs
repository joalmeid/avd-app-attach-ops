using System;
using System.Reflection;

namespace simple_app
{
    class Program
    {
        static readonly string appName = Assembly.GetEntryAssembly().GetName().Name;

        static void Main(string[] args)
        {
            string timestamp = DateTime.Now.ToString("ddMMyyHHmm");
            Console.WriteLine($"[{timestamp}] Simple-app running...");

            Console.ReadLine();
        }

    }
}
