import os
from git import Repo

repo = Repo("../../../cloudguru-resumechallenge-main")
index = repo.index
print("=============== list modified files ===============")

diff = repo.git.diff('HEAD~1..HEAD', name_only=True)
print(diff)
print('\n')

if "website/" in diff:
    print("This modified file is under the 'website' folder.")
    print("::set-output name=run_job::true")
    exit #exit return 0 == Success
else:
    print('No files required for upload \n')
    print("::set-output name=run_job::false")
    exit(1) #exit return 1 == Failed