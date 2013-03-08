#!/bin/bash
# inspired by https://github.com/lviggiano/owner/blob/gh-pages/bin/autogen

input_files[0]='https://raw.github.com/StimOmatic/StimOmatic/master/README.md'
input_files[1]='https://raw.github.com/StimOmatic/StimOmatic/master/FAQ.md'
input_files[2]='https://raw.github.com/StimOmatic/StimOmatic/master/INSTALL.md'

output_files[0]='index.html'
output_files[1]='faq.html'
output_files[2]='install.html'


GITHUB_API_URL=https://api.github.com/markdown/raw


# loop over all indices
for index in ${!input_files[*]}
do
    printf "input: %s; output: %s\n" ${input_files[$index]} ${output_files[$index]}
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
done

