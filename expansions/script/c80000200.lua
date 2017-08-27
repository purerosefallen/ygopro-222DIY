--口袋妖怪 赫拉克罗斯
function c80000200.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()	
end
