--ＤＭ 格斗狮子兽
function c80009096.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_BEAST),aux.NonTuner(Card.IsType,TYPE_NORMAL),1)
	c:EnableReviveLimit()	
end
