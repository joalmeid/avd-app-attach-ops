using System;
using System.IO;
using System.Reflection;

namespace psf_simple_app
{
    class Program
    {
        static readonly string appName = Assembly.GetEntryAssembly().GetName().Name;

        static void Main(string[] args)
        {
            string timestamp = DateTime.Now.ToString("ddMMyyHHmm");
            string writeFileContent = $"[{timestamp}] Write a file by Simple App";
            string logFileName = $"{timestamp}-psf-simple-app.log";

            WriteFile(null, logFileName, writeFileContent, "nopath");
            WriteFile(@$"{Directory.GetCurrentDirectory()}", logFileName, writeFileContent, "defaultapp");
            WriteFile(@$"c:\temp\{appName}", logFileName, writeFileContent, "temp");
            WriteFile(@$"{Environment.GetFolderPath(Environment.SpecialFolder.CommonApplicationData)}\{appName}", logFileName, writeFileContent, "ProgramData");
            WriteFile(@$"{Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData)}\{appName}", logFileName, writeFileContent, "LocalAppData");
            WriteFile($@"{Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData)}\{appName}", logFileName, writeFileContent, "RoamAppData");
            ReadConfigFile(@$"{Directory.GetCurrentDirectory()}", "psf-simple-app.config");

            Console.ReadLine();
        }

        private static void WriteFile(string path, string fileName, string writeFileContent, string folderDescription)
        {
            try
            {
                string fullPath, finalFileName;
                fullPath = finalFileName = $"{folderDescription}-{fileName}";

                if (path != null)
                {
                    if (!Directory.Exists(path))
                    {
                        Directory.CreateDirectory(path);
                    }
                    fullPath = Path.Combine(path, finalFileName);
                }
                File.WriteAllText(fullPath, writeFileContent);
                Console.WriteLine($"Successfullly wrote in {folderDescription} folder : {fullPath}");
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Exception: {ex.Message}");
            }
        }

        private static void ReadConfigFile(string filePath, string fileName)
        {
            // Reading file
            try
            {
                // Open the text file using a stream reader.
                using (var sr = new StreamReader(Path.Combine(filePath, fileName)))
                {
                    string readFileContent = sr.ReadToEnd();

                    Console.WriteLine($@"Read config file successfully: {readFileContent}");
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Exception: {ex.Message}");
            }
        }
    }
}
