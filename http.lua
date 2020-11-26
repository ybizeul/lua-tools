--[[
This function parses a HTTP request like :

GET /my/page?arg1=text&arg2=8&arg3

and returns a table with :

result.method => GET
result.args   => { arg1: "text", arg2: 8, arg3: 1}
result.path   => /my/page

--]]
function parse_query(str)
    path_start = string.find(str," ") + 1
    path_end = string.find(str," ",path_start)

    if path_end then
        path = string.sub(str,path_start,path_end-1)
    else
        path = string.sub(str,path_start,string.len(str))
    end

    method=string.sub(str,1,path_start-2)
    query_start = string.find(path,"?")
    arguments = {}

    if query_start then
        query_string = string.sub(path,query_start+1,string.len(path))
        path=string.sub(path,1,query_start-1)
        -- Find arguments
        a = {}
        i = 0
        j = 0
        while true do
            j = string.find(query_string, "&", i+1)
            if not j then 
                s=string.sub(query_string,i+1,string.len(query_string))
                table.insert(a,s)
                break
            end

            s=string.sub(query_string,i+1,j-1)
            table.insert(a,s)

            i=j
        end

        for k, v in pairs(a) do
            e=string.find(v,"=")
            if e then
                value=string.sub(v,e+1,string.len(v))
                converted = tonumber(value)
                if converted then
                    arguments[string.sub(v,1,e-1)] = converted
                else
                    arguments[string.sub(v,1,e-1)] = value
                end
            else
                arguments[v] = 1
            end
        end
    end

    result={}
    result.arguments=arguments
    result.path=path
    result.method=method

    return result
end
