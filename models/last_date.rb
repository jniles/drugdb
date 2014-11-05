#Keep track of the last date we updated stuff in this DB

class LastDate

	include Datamapper::Resource

	property :last_update    ,Date

	#delete any new rows
end 
