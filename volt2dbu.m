function dbu = volt2dbu(V)
% DBU2VOLT : convert dBu to Volt
% Usage : dbu = VOLT2DBU(V)
% [Input]  :V   [Volt]
% [Output] :dbu [dBu]

dbu = 20*log10(V./0.775);
end