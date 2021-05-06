for f in $(find . -type f | grep ".sh$"); do
    if [ $( grep -l "run_all_tools.sh" $f ) ]; 
        then
        echo "sed -i 's/run_all_tools.sh/run_all_tools.sh/g' $f " >> change_main_script_name.sh;
        echo "git stage $f"  >> change_main_script_name_commit.sh;
    fi
done
