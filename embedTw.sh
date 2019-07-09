# The text of the tweet
msg="Tweet embeded in a html page file."

# The twitter account
twtAcc=$1

# The tweet
ans1="$(twurl25 -d "status=$msg" /1.1/statuses/update.json)"

# Extract the id of the tweet
myID=${ans1#*\"id\":}
myID=${myID%\"text\"*}
myID=${myID%,\"id_str\"*}

#create the url of the embed
turl=""https://twitter.com/"$twtAcc"/status/"$myID"

# use the embed API (with setting the link_color parmeter )
ans2=$(twurl25 -H publish.twitter.com "/oembed?url=$turl&link_color=#3aafa9" | jq  '.'  )

#extract the html part
ans3=${ans2#*\"html\":}
ans3=${ans3#*\"}
ans3=${ans3%<script*}

#remove the backlashes
ans3=$(echo $ans3 | tr -d '\\')

# the phrase in the html file to replace with the embedding
toR="--ToReplace--"

workdir=$(pwd)

# insert the embedding in the html file
sed -i  "s+${toR}+${ans3}+g"   "$workdir"/emb.html""
sed -i  "s/${toR}/\&/g"   "$workdir"/emb.html""


