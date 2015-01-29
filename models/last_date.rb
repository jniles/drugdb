#Keep track of the last date we updated stuff in this DB
class LastDate
	include DataMapper::Resource

	property :id             ,Serial
	property :last_update    ,Date

	#delete any new rows
end 
