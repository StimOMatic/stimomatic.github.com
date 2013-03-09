#!/bin/bash
# inspired by: https://github.com/lviggiano/owner/blob/gh-pages/bin/autogen
# see also:    http://developer.github.com/v3/markdown/#render-a-markdown-document-in-raw-mode 

input_files[0]='https://raw.github.com/StimOmatic/StimOmatic/master/README.md'
input_files[1]='https://raw.github.com/StimOmatic/StimOmatic/master/FAQ.md'
input_files[2]='https://raw.github.com/StimOmatic/StimOmatic/master/INSTALL.md'
input_files[3]='https://raw.github.com/StimOmatic/StimOmatic/master/python/OpenGLPlotting/pomp/docs/INSTALL.md'
input_files[4]='https://raw.github.com/StimOmatic/StimOmatic/master/matlab/psychophysics-example/INSTALL.md'

output_files[0]='index.html'
output_files[1]='FAQ.html'
output_files[2]='INSTALL.html'
output_files[3]='INSTALL.html'
output_files[4]='INSTALL.html'

basepath='fake_root/'

output_dir[0]=$basepath
output_dir[1]=$basepath
output_dir[2]=$basepath
output_dir[3]=$basepath'python/OpenGLPlotting/pomp/docs/'
output_dir[4]=$basepath'matlab/psychophysics-example/'

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
    path_out=${output_dir[$index]}
    full_file_out=$path_out$file_out
    
    # create output path
    mkdir -p $path_out
    
    # create header
    cat header > $full_file_out
    # process content
    curl -s $file_in | curl -s --data-binary @- -H 'Content-Type: text/plain' $GITHUB_API_URL >> $full_file_out
    # add footer
    cat footer >> $full_file_out
    # replace ".md" hrefs with ".html"
    sed -i 's|<a[^>]* href="\([^"]*\).md|<a href="\1.html|g' $full_file_out
    # replace ".md" text (between <a></a>) with "" - commented out March 9th 2013
    #sed -i 's/\.md//g' $full_file_out
done

# move generated files to target directory
cp -fR $basepath/* ../
rm -fR $basepath

