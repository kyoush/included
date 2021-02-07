function V = dbu2volt(dbu)
% DBU2VOLT : convert Volt to dBu
% Usage : V = DBU2VOLT(dbu)
% [Input]  :dbu [dBu]
% [Output] :V   [Volt]

V = 10.^(dbu./20.0) .* 0.775;
end