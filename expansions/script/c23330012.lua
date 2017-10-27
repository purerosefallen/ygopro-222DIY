--极秘调械 三色晶
function c23330012.initial_effect(c)
	--双星同调
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c23330012.syncon)
	e0:SetOperation(c23330012.synop)
	e0:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e0)
	--不能作为融合素材
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--不能作为超量素材
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--不受超量怪兽发动的效果影响
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetValue(c23330012.efilter)
	c:RegisterEffect(e3)
	--禁止超量召唤
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,1)
	e4:SetTarget(c23330012.splimit)
	c:RegisterEffect(e4)
end
function c23330012.efilter(e,te)
	return te:IsActiveType(TYPE_MONSTER) and te:IsActivated() and te:GetOwner():IsType(TYPE_XYZ)
end
function c23330012.splimit(e,c,tp,sumtp,sumpos)
	return bit.band(sumtp,SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ
end
function c23330012.matfilter1(c,syncard)
	return c:IsType(TYPE_TUNER) and (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and c:IsCanBeSynchroMaterial(syncard)
end
function c23330012.matfilter2(c,syncard)
	return c:IsNotTuner() and c:IsFaceup() and c:IsCanBeSynchroMaterial(syncard)
end
function c23330012.synfilter1(c,syncard,lv,g1,g2,g3)
	local f1=c.tuner_filter
	if c:IsHasEffect(EFFECT_HAND_SYNCHRO) then
		return g3:IsExists(c23330012.synfilter2,1,c,syncard,lv,g2,f1,c)
	else
		return g1:IsExists(c23330012.synfilter2,1,c,syncard,lv,g2,f1,c)
	end
end
function c23330012.synfilter2(c,syncard,lv,g2,f1,tuner1)
	local f2=c.tuner_filter
	if f1 and not f1(c) then return false end
	if f2 and not f2(tuner1) then return false end
	local mg=g2:Filter(c23330012.synfilter3,nil,f1,f2)
	Duel.SetSelectedCard(Group.FromCards(c,tuner1))
	return mg:CheckWithSumEqual(Card.GetSynchroLevel,lv,1,1,syncard)
end
function c23330012.synfilter3(c,f1,f2)
	return (not f1 or f1(c)) and (not f2 or f2(c))
end	
function c23330012.syncon(e,c,tuner,mg)
	if c==nil then return true end
	local tp=c:GetControler()
	if Duel.GetMZoneCount(tp)<-2 then return false end
	local g1=nil
	local g2=nil
	local g3=nil
	if mg then
		g1=mg:Filter(c23330012.matfilter1,nil,c)
		g2=mg:Filter(c23330012.matfilter2,nil,c)
		g3=g1:Clone()
	else
		g1=Duel.GetMatchingGroup(c23330012.matfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
		g2=Duel.GetMatchingGroup(c23330012.matfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
		g3=Duel.GetMatchingGroup(c23330012.matfilter1,tp,LOCATION_MZONE+LOCATION_HAND,LOCATION_MZONE,nil,c)
	end
	local pe=Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_SMATERIAL)
	local lv=c:GetLevel()
	if tuner then
		local f1=tuner.tuner_filter
		if not pe then
			return g1:IsExists(c23330012.synfilter2,1,tuner,c,lv,g2,f1,tuner)
		else
			return c23330012.synfilter2(pe:GetOwner(),c,lv,g2,f1,tuner)
		end
	end
	if not pe then
		return g1:IsExists(c23330012.synfilter1,1,nil,c,lv,g1,g2,g3)
	else
		return c23330012.synfilter1(pe:GetOwner(),c,lv,g1,g2,g3)
	end
end
function c23330012.synop(e,tp,eg,ep,ev,re,r,rp,c,tuner,mg)
	local g=Group.CreateGroup()
	local g1=nil
	local g2=nil
	local g3=nil
	if mg then
		g1=mg:Filter(c23330012.matfilter1,nil,c)
		g2=mg:Filter(c23330012.matfilter2,nil,c)
		g3=g1:Clone()
	else
		g1=Duel.GetMatchingGroup(c23330012.matfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
		g2=Duel.GetMatchingGroup(c23330012.matfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
		g3=Duel.GetMatchingGroup(c23330012.matfilter1,tp,LOCATION_MZONE+LOCATION_HAND,LOCATION_MZONE,nil,c)
	end
	local pe=Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_SMATERIAL)
	local lv=c:GetLevel()
	if tuner then
		g:AddCard(tuner)
		local f1=tuner.tuner_filter
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local tuner2=nil
		if not pe then
			local t2=g1:FilterSelect(tp,c23330012.synfilter2,1,1,tuner,c,lv,g2,f1,tuner)
			tuner2=t2:GetFirst()
		else
			tuner2=pe:GetOwner()
			Group.FromCards(tuner2):Select(tp,1,1,nil)
		end
		g:AddCard(tuner2)
		local f2=tuner2.tuner_filter
		local mg2=g2:Filter(c23330012.synfilter3,nil,f1,f2)
		Duel.SetSelectedCard(g)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local m3=mg2:SelectWithSumEqual(tp,Card.GetSynchroLevel,lv,1,1,c)
		g:Merge(m3)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local tuner1=nil
		if not pe then
			local t1=g1:FilterSelect(tp,c23330012.synfilter1,1,1,nil,c,lv,g1,g2,g3)
			tuner1=t1:GetFirst()
		else
			tuner1=pe:GetOwner()
			Group.FromCards(tuner1):Select(tp,1,1,nil)
		end
		g:AddCard(tuner1)
		local f1=tuner1.tuner_filter
		local t2=nil
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		if tuner1:IsHasEffect(EFFECT_HAND_SYNCHRO) then
			t2=g3:FilterSelect(tp,c23330012.synfilter2,1,1,tuner1,c,lv,g2,f1,tuner1)
		else
			t2=g1:FilterSelect(tp,c23330012.synfilter2,1,1,tuner1,c,lv,g2,f1,tuner1)
		end
		local tuner2=t2:GetFirst()
		g:AddCard(tuner2)
		local f2=tuner2.tuner_filter
		local mg2=g2:Filter(c23330012.synfilter3,nil,f1,f2)
		Duel.SetSelectedCard(g)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local m3=mg2:SelectWithSumEqual(tp,Card.GetSynchroLevel,lv,1,1,c)
		g:Merge(m3)
	end
	c:SetMaterial(g)
	Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO)
end