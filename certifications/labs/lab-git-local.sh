git clone https://github.com/vikasrajput/az400 

cd az400 

#build local dotnet solution 
mkdir dotnetmvc; cd dotnetmvc
code . 
code> dotnet new mvc
code>dotnet build 
code>dotnet run 
# browse https://localhost:5001. stop solution. 
code>git add . 
code>git commit -m "added solution" 
 
# explore branching 
git branch --list 
git branch new-homepage
git checkout new-homepage 
git branch --list 
# change ~\Views\Home\Index.cshtml in Code
git status 
git commit -m "updated home page" 
git checkout master 
git merge new-homepage
git log -v 
git log -p 
