# github action backport commits

The GitHub Action enables you to backport the latest commit of the current branch to other branches.
You can imagine for example putting this github action on master, and automatically backport to your previous release.

The action won't push directly to your backport branches, instead, it will create a PR. This allows you
to make sure the backport compiles and passes your tests before merging.
The auto-merge of the PR is not covered by this github action.

# Usage

## examples

For back-porting to your branches 'releases-*':

```
 - name: Backport
      uses: qcastel/github-actions-backport@master
      with:
        backport-branches-regex: "releases*"
        
        git-release-bot-name: "release-bot"
        git-release-bot-email: "release-bot@example.com"
        
        access-token: ${{ secrets.GITHUB_ACCESS_TOKEN }}
```

To add default user reviewers to the PR:

```
 - name: Backport
      uses: qcastel/github-actions-backport@master
      with:
        backport-branches-regex: "releases*"

        reviewers-users: ['alice', 'bob']
        
        git-release-bot-name: "release-bot"
        git-release-bot-email: "release-bot@example.com"
        
        access-token: ${{ secrets.GITHUB_ACCESS_TOKEN }}

```

To add default team reviewers to the PR:

```
 - name: Backport
      uses: qcastel/github-actions-backport@master
      with:
        backport-branches-regex: "releases*"

        reviewers-teams: ['team-a']
        
        git-release-bot-name: "release-bot"
        git-release-bot-email: "release-bot@example.com"
        
        access-token: ${{ secrets.GITHUB_ACCESS_TOKEN }}

```

To setup the bot to sign commits:

```
 - name: Backport
      uses: qcastel/github-actions-backport@master
      with:
        backport-branches-regex: "releases*"

        reviewers-teams: ['team-a']
        
        git-release-bot-name: "release-bot"
        git-release-bot-email: "release-bot@example.com"
        
        gpg-enabled: "true"
        gpg-key-id: ${{ secrets.GITHUB_GPG_KEY_ID }}
        gpg-key: ${{ secrets.GITHUB_GPG_KEY }}

        access-token: ${{ secrets.GITHUB_ACCESS_TOKEN }}

```


We welcome contributions! If your usecase is slightly different than us, just suggest a RFE or contribute to this repo directly.

## Setup the bot gpg key

Setting up a gpg key for your bot is a good security feature. This way, you can enforce sign commits in your repo,
even for your release bot.

![Screenshot-2019-11-28-at-20-47-06.png](https://i.postimg.cc/9F6cxpqm/Screenshot-2019-11-28-at-20-47-06.png)

- Create dedicate github account for your bot and add him into your team for your git repo.
- Create a new GPG key: https://help.github.com/en/github/authenticating-to-github/generating-a-new-gpg-key

This github action needs the key ID and the key base64 encoded.

```$xslt
        gpg-key-id: ${{ secrets.GITHUB_GPG_KEY_ID }}
        gpg-key: ${{ secrets.GITHUB_GPG_KEY }}
```

### Get the KID

You can get the key ID doing the following:

```$xslt
gpg --list-secret-keys --keyid-format LONG

sec   rsa2048/3EFC3104C0088B08 2019-11-28 [SC]
      CBFD9020DAC388A77C68385C3EFC3104C0088B08
uid                 [ultimate] bot-openbanking4-dev (it's the bot openbanking4.dev key) <bot@openbanking4.dev>
ssb   rsa2048/7D1523C9952204C1 2019-11-28 [E]

```
The key ID for my bot is 3EFC3104C0088B08. Add this value into your github secret for this repo, under `GITHUB_GPG_KEY_ID` 
PS: the key id is not really a secret but we found more elegant to store it there than in plain text in the github action yml

### Get the GPG private key

Now we need the raw key and base64 encode
```$xslt
gpg --export-secret-keys --armor 3EFC3104C0088B08 | base64
```

Copy the result and add it in your githup repo secrets under `GITHUB_GPG_KEY`.

Go the bot account in github and import this GPG key into its profile.

# License
The Dockerfile and associated scripts and documentation in this project are released under the MIT License.

