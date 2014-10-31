function gate = gates()
gate.new_gate = @new_gate;
gate.rotate_gate = @rotate_gate;

function output = rotate_gate(angle)
%settings
fid = fopen('rotationgate.bs2','wt');
fprintf(fid,'%s\n',''' *Stamp Configurations!*');
fprintf(fid,'%s\n',''' {$PBASIC 2.5}');
fprintf(fid,'%s\n',''' {$STAMP BS2pe}');
fprintf(fid,'%s\n',''' {$PORT COM3}');
fprintf(fid,'%s\n','');

%Variables
fprintf(fid,'%s\n','''Variables!');
fprintf(fid,'%s\n','i VAR Byte');
fprintf(fid,'%s\n','l VAR Byte');
fprintf(fid,'%s\n','j VAR Byte');
fprintf(fid,'%s\n','a VAR Word(4)');
fprintf(fid,'%s\n','r VAR Byte(4)');
fprintf(fid,'%s\n','');

fprintf(fid,'%s\n','a(0) = 910 ^ 1386');
fprintf(fid,'%s\n','a(1) = 14 ^ 1386');
fprintf(fid,'%s\n','a(2) = 3185 ^ 1386');
fprintf(fid,'%s\n','a(3) = 49 ^ 1386');
fprintf(fid,'%s\n','');

fprintf(fid,'%s\n','r(0) = 6');
fprintf(fid,'%s\n','r(1) = 5');
fprintf(fid,'%s\n','r(2) = 6');
fprintf(fid,'%s\n','r(3) = 5');
fprintf(fid,'%s\n','');

%Set directions
fprintf(fid,'%s\n','''Directions!');
fprintf(fid,'%s\n','DIRS = $FFFF');
fprintf(fid,'%s\n','OUTS = 0');
fprintf(fid,'%s\n','');

%Start stance
fprintf(fid,'%s\n','''Start Stance!');
fprintf(fid,'%s\n','FOR i = 0 TO 20');
fprintf(fid,'%s\n','  OUTS = $FFFF');
fprintf(fid,'%s\n','  PULSOUT 12, 300');
fprintf(fid,'%s\n','  OUTS = %0000010101101010');
fprintf(fid,'%s\n','  PULSOUT 12, 400');
fprintf(fid,'%s\n','  OUTS = 0');
fprintf(fid,'%s\n','  PAUSE 20');
fprintf(fid,'%s\n','NEXT');
fprintf(fid,'%s\n','');

fprintf(fid,'%s\n','FOR i = 0 TO 20');
fprintf(fid,'%s\n','  OUTS = $FFFF');
fprintf(fid,'%s\n','  PULSOUT 12, 300');
fprintf(fid,'%s\n','  OUTS = %0000100100101010');
fprintf(fid,'%s\n','  PULSOUT 12, 400');
fprintf(fid,'%s\n','  OUTS = 0');
fprintf(fid,'%s\n','  PAUSE 20');
fprintf(fid,'%s\n','NEXT');
fprintf(fid,'%s\n','');

fprintf(fid,'%s\n','FOR i = 0 TO 20');
fprintf(fid,'%s\n','  OUTS = $FFFF');
fprintf(fid,'%s\n','  PULSOUT 12, 300');
fprintf(fid,'%s\n','  OUTS = %0000010101101010');
fprintf(fid,'%s\n','  PULSOUT 12, 400');
fprintf(fid,'%s\n','  OUTS = 0');
fprintf(fid,'%s\n','  PAUSE 20');
fprintf(fid,'%s\n','NEXT');
fprintf(fid,'%s\n','');

fprintf(fid,'%s\n','FOR i = 0 TO 20');
fprintf(fid,'%s\n','  OUTS = $FFFF');
fprintf(fid,'%s\n','  PULSOUT 12, 300');
fprintf(fid,'%s\n','  OUTS = %0000011011101010');
fprintf(fid,'%s\n','  PULSOUT 12, 400');
fprintf(fid,'%s\n','  OUTS = 0');
fprintf(fid,'%s\n','  PAUSE 20');
fprintf(fid,'%s\n','NEXT');
fprintf(fid,'%s\n','');

fprintf(fid,'%s\n','FOR i = 0 TO 20');
fprintf(fid,'%s\n','  OUTS = $FFFF');
fprintf(fid,'%s\n','  PULSOUT 12, 300');
fprintf(fid,'%s\n','  OUTS = %0000010101101010');
fprintf(fid,'%s\n','  PULSOUT 12, 400');
fprintf(fid,'%s\n','  OUTS = 0');
fprintf(fid,'%s\n','  PAUSE 20');
fprintf(fid,'%s\n','NEXT');
fprintf(fid,'%s\n','');


activations = ceil(abs(angle)*11/360);
if activations > 0
    fprintf(fid,'%s\n','''Loop Section!');
    fprintf(fid,'%s%i\n','FOR l = 1 TO ',activations);
    fprintf(fid,'%s\n','  FOR i = 0 TO 3');
    fprintf(fid,'%s\n','    FOR j = 1 TO r(i)');
    fprintf(fid,'%s\n','      OUTS = $FFFF');
    fprintf(fid,'%s\n','      PULSOUT 12, 300');
    if angle >= 0
        fprintf(fid,'%s\n','      OUTS = a(i) ^ %0000000000101010');
    else
        fprintf(fid,'%s\n','      OUTS = a(i) ^ %0000000000010101');
    end
    fprintf(fid,'%s\n','      PULSOUT 12, 400');
    fprintf(fid,'%s\n','      OUTS = 0');
    fprintf(fid,'%s\n','      PAUSE 20');
    fprintf(fid,'%s\n','    NEXT');
    fprintf(fid,'%s\n','  NEXT');
    fprintf(fid,'%s\n','NEXT');
    fprintf(fid,'%s\n','');
end

%Start stance
fprintf(fid,'%s\n','''Start Stance!');
fprintf(fid,'%s\n','FOR i = 0 TO 20');
fprintf(fid,'%s\n','  OUTS = $FFFF');
fprintf(fid,'%s\n','  PULSOUT 12, 300');
fprintf(fid,'%s\n','  OUTS = %0000010101101010');
fprintf(fid,'%s\n','  PULSOUT 12, 400');
fprintf(fid,'%s\n','  OUTS = 0');
fprintf(fid,'%s\n','  PAUSE 20');
fprintf(fid,'%s\n','NEXT');
fprintf(fid,'%s\n','');

fprintf(fid,'%s\n','FOR i = 0 TO 20');
fprintf(fid,'%s\n','  OUTS = $FFFF');
fprintf(fid,'%s\n','  PULSOUT 12, 300');
fprintf(fid,'%s\n','  OUTS = %0000100100101010');
fprintf(fid,'%s\n','  PULSOUT 12, 400');
fprintf(fid,'%s\n','  OUTS = 0');
fprintf(fid,'%s\n','  PAUSE 20');
fprintf(fid,'%s\n','NEXT');
fprintf(fid,'%s\n','');

fprintf(fid,'%s\n','FOR i = 0 TO 20');
fprintf(fid,'%s\n','  OUTS = $FFFF');
fprintf(fid,'%s\n','  PULSOUT 12, 300');
fprintf(fid,'%s\n','  OUTS = %0000010101101010');
fprintf(fid,'%s\n','  PULSOUT 12, 400');
fprintf(fid,'%s\n','  OUTS = 0');
fprintf(fid,'%s\n','  PAUSE 20');
fprintf(fid,'%s\n','NEXT');
fprintf(fid,'%s\n','');

fprintf(fid,'%s\n','FOR i = 0 TO 20');
fprintf(fid,'%s\n','  OUTS = $FFFF');
fprintf(fid,'%s\n','  PULSOUT 12, 300');
fprintf(fid,'%s\n','  OUTS = %0000011011101010');
fprintf(fid,'%s\n','  PULSOUT 12, 400');
fprintf(fid,'%s\n','  OUTS = 0');
fprintf(fid,'%s\n','  PAUSE 20');
fprintf(fid,'%s\n','NEXT');
fprintf(fid,'%s\n','');

fprintf(fid,'%s\n','FOR i = 0 TO 20');
fprintf(fid,'%s\n','  OUTS = $FFFF');
fprintf(fid,'%s\n','  PULSOUT 12, 300');
fprintf(fid,'%s\n','  OUTS = %0000010101101010');
fprintf(fid,'%s\n','  PULSOUT 12, 400');
fprintf(fid,'%s\n','  OUTS = 0');
fprintf(fid,'%s\n','  PAUSE 20');
fprintf(fid,'%s\n','NEXT');
fprintf(fid,'%s\n','');

fprintf(fid,'%s\n','END');
fclose(fid);
output = activations;

function output = collect_genes(gene)
if gene(1)~=0;
    output = gene;
else
    output = [];
end

function output = get_moves(gene)
output = gene(1);

function new_gate(ind)
global num_moves;
all_down_forward = 1386;

start = ind{3}{1};
loop = cellfun(@collect_genes,ind{4},'UniformOutput',false);
loop(cellfun(@(loop) isempty(loop),loop)) = [];
loop_moves = sum(cellfun(@get_moves,loop));

%settings
fid = fopen('newgate.bs2','wt');
fprintf(fid,'%s\n',''' *Stamp Configurations!*');
fprintf(fid,'%s\n',''' {$PBASIC 2.5}');
fprintf(fid,'%s\n',''' {$STAMP BS2pe}');
fprintf(fid,'%s\n',''' {$PORT COM3}');
fprintf(fid,'%s\n','');

%Variables
fprintf(fid,'%s\n','''Variables!');
fprintf(fid,'%s\n','i VAR Nib');
fprintf(fid,'%s%i%s\n','a VAR Word(',length(loop),')');
fprintf(fid,'%s\n','r VAR Byte');
fprintf(fid,'%s\n','');

%Loop Activations
fprintf(fid,'%s\n','''Loop Activations!');
for i=1:length(loop)
    fprintf(fid,'%s%i%s%i%s%i\n','a(',i-1,') = ',loop{i}(2),' ^ ',all_down_forward);
end
fprintf(fid,'%s\n','');

%Loop repetitions
fprintf(fid,'%s\n','''Loop Repetitions!');
for i=1:length(loop)
    fprintf(fid,'%s%i%s%i\n','PUT ',i-1,', ',loop{i}(1));
end
fprintf(fid,'%s\n','');
fprintf(fid,'%s\n','PUT 12, 0');
fprintf(fid,'%s\n','');

%Set directions
fprintf(fid,'%s\n','''Directions!');
fprintf(fid,'%s\n','DIRS = $FFFF');
fprintf(fid,'%s\n','OUTS = 0');
fprintf(fid,'%s\n','');


%Start section execution
fprintf(fid,'%s%i\n','''Start Section!: Total Activations ',start(1));
fprintf(fid,'%s\n','');
if start(1) ~= 0
    fprintf(fid,'%s\n','''Start Section!');
    fprintf(fid,'%s%i\n','FOR r = 0 TO ',start(1)-1);
    fprintf(fid,'%s\n','  OUTS = $FFFF');
    fprintf(fid,'%s\n','  PULSOUT 12, 300');
    fprintf(fid,'%s%i\n','  OUTS = ',start(2));
    fprintf(fid,'%s\n','  PULSOUT 12, 400');
    fprintf(fid,'%s\n','  OUTS = 0');
    fprintf(fid,'%s\n','  PAUSE 20');
    fprintf(fid,'%s\n','NEXT');
    fprintf(fid,'%s\n','');
end


%Loop section execution
moves = num_moves - start(1);
fprintf(fid,'%s%i\n','''Loop Section!: Total Activations ',loop_moves);
fprintf(fid,'%s%i\n','''Activations Remaining ',moves);
fprintf(fid,'%s\n','');
multiple = floor(moves/loop_moves);
remaining = mod(moves,loop_moves);

fprintf(fid,'%s\n','''Loop Section!');
fprintf(fid,'%s\n','');
fprintf(fid,'%s\n','GET 12,r');
if multiple > 0
    fprintf(fid,'%s%i\n','DO WHILE r < ',multiple);
    fprintf(fid,'%s\n','  r = r + 1');
    fprintf(fid,'%s\n','  PUT 12, r');
    fprintf(fid,'%s%i\n','  FOR i = 0 TO ',length(loop)-1);
    fprintf(fid,'%s\n','    GET i, r');
    fprintf(fid,'%s\n','    DO WHILE r > 0');
    fprintf(fid,'%s\n','      OUTS = $FFFF');
    fprintf(fid,'%s\n','      PULSOUT 12, 300');
    fprintf(fid,'%s\n','      OUTS = a(i)');
    fprintf(fid,'%s\n','      PULSOUT 12, 400');
    fprintf(fid,'%s\n','      OUTS = 0');
    fprintf(fid,'%s\n','      PAUSE 20');
    fprintf(fid,'%s\n','      r = r - 1');
    fprintf(fid,'%s\n','    LOOP');
    fprintf(fid,'%s\n','  NEXT');
    fprintf(fid,'%s\n','  GET 12, r');
    fprintf(fid,'%s\n','LOOP');
    fprintf(fid,'%s\n','');
end


%Print remaining loop genes
fprintf(fid,'%s%i\n','''Remaining Loop Genes!: Total Activations ',remaining');
i = 0;
while remaining > 0
    if remaining - loop{i+1}(1) >= 0
        fprintf(fid,'%s%i\n','FOR r = 1 TO ',loop{i+1}(1));
        remaining = remaining - loop{i+1}(1);
    else
        fprintf(fid,'%s%i\n','FOR r = 1 TO ',remaining);
        remaining = 0;
    end
    fprintf(fid,'%s\n','  OUTS = $FFFF');
    fprintf(fid,'%s\n','  PULSOUT 12, 300');
    fprintf(fid,'%s%i%s\n','  OUTS = a(',i,')');
    fprintf(fid,'%s\n','  PULSOUT 12, 400');
    fprintf(fid,'%s\n','  OUTS = 0');
    fprintf(fid,'%s\n','  PAUSE 20');
    fprintf(fid,'%s\n','NEXT');
    fprintf(fid,'%s\n','');
    i=i+1;
end
fprintf(fid,'%s\n','END');
fclose(fid);

