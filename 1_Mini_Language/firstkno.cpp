//first k prime numbers 
begin
var $k : int;
var $num : int;
var $count : int;
var $is_prime : int;

read($k);                
$count: = 0;
$num: = 2;

while $count < $k do      
    begin
        $is_prime : = 1;      
        var $i : int;
        $i: = 2;

        while $i* $i <= $num do   
            begin
                if $num% $i == 0 then
                $is_prime : = 0;
                $i: = $i + 1;
            end;

    if $is_prime == 1 then     
        begin
            write($num);
            $count: = $count + 1;
        end;

        $num: = $num + 1;        
     end;
end;