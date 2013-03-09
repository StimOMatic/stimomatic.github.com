#!/bin/bash
# inspired by: https://github.com/lviggiano/owner/blob/gh-pages/bin/autogen
# see also:    http://developer.github.com/v3/markdown/#render-a-markdown-document-in-raw-mode 

input_files[0]='https://raw.github.com/StimOmatic/StimOmatic/master/README.md'
input_files[1]='https://raw.github.com/StimOmatic/StimOmatic/master/FAQ.md'
input_files[2]='https://raw.github.com/StimOmatic/StimOmatic/master/INSTALL.md'

output_files[0]='index.html'
output_files[1]='FAQ.html'
output_files[2]='INSTALL.html'

GITHUB_API_URL=https://api.github.com/markdown/raw

# loop over all indices and show me the file mappings
for index in ${!input_files[*]}
do
    printf "%s ==> %s\n" ${input_files[$index]} ${output_files[$index]}
done

echo "processing files ..."

for index in ${!input_files[*]}
do
    # grab output file name
    file_in=${input_files[$index]}
    file_out=${output_files[$index]}
    # create header
    cat header > $file_out
    # process content
    curl -s $file_in | curl -s --data-binary @- -H 'Content-Type: text/plain' $GITHUB_API_URL >> $file_out
    # add footer
    cat footer >> $file_out
    # replace ".md" hrefs to ".html"
    sed -i 's|<a[^>]* href="\([^"]*\).md|<a href="\1.html|g' $file_out
    # replace ".md" text (between <a></a>) with ""
    sed -i 's/\.md//g' $file_out
done

# move generated file to target directory
mv *.html ../

