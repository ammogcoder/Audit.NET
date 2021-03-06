@echo off
start "" "D:\Program Files\MongoDB\Server\3.4\bin\mongod.exe"
start "" /D c:\redis "c:\redis\redis-server.exe"
net start mysql57
net start mssqlserver
net start postgresql-x64-9.6

cd ..
dotnet restore
cd test

cd Audit.Mvc.UnitTest
dotnet test --logger:"console;verbosity=normal"
echo continue...

echo Running...

cd ..

cd Audit.UnitTest
dotnet test --logger:"console;verbosity=normal"
echo continue...

echo Running...
cd ..

cd Audit.WebApi.UnitTest
dotnet test --logger:"console;verbosity=normal"
echo continue...

echo Running...

cd ..

cd Audit.DynamicProxy.UnitTest
dotnet test --logger:"console;verbosity=normal"
echo continue...

echo Running...
cd ..

cd Audit.EntityFramework.UnitTest
"C:\Windows\Microsoft.NET\Framework\v4.0.30319\MSBuild.exe"
..\..\packages\NUnit.ConsoleRunner.3.7.0\tools\nunit3-console.exe bin\Debug\Audit.EntityFramework.UnitTest.dll --noresult --where=cat=Sql
..\..\packages\NUnit.ConsoleRunner.3.7.0\tools\nunit3-console.exe bin\Debug\Audit.EntityFramework.UnitTest.dll --noresult --where=cat=LocalDb
echo continue...

echo Running...
cd ..

cd Audit.Redis.UnitTest
dotnet test --logger:"console;verbosity=normal"
echo continue...

echo Running...
cd ..

cd Audit.Integration.AspNetCore
dotnet run
echo continue...

cd ..

cd Audit.IntegrationTest
dotnet test --logger:"console;verbosity=normal" --filter "TestCategory!=AzureDocDb&TestCategory!=AzureBlob&TestCategory!=WCF"
dotnet test --logger:"console;verbosity=normal" -f net451 --filter "TestCategory=WCF&TestCategory!=Async"
dotnet test --logger:"console;verbosity=normal" -f net451 --filter "TestCategory=WCF&TestCategory=Async"
echo continue...

cd ..

del TestResult.xml /s

net stop mssqlserver
net stop mysql57
net stop postgresql-x64-9.6
taskkill /f /im mongod.exe
taskkill /f /im redis-server.exe