# shell script to import sample laws
echo "Import sample Virginia laws. Use curl to submit import on Statedecoded admin form"

time curl --data 'action=parse&edition_option=new&new_edition_name=2014-sample&new_edition_slug=2014-sample&make_current=1' 'http://localhost:80/admin/?page=parse&noframe=1'