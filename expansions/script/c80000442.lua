--ＬＰＭ 拉帝欧斯
function c80000442.initial_effect(c)
	--synchro summon
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c80000442.syncon)
	e1:SetOperation(c80000442.synop)
	e1:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e1) 
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c80000442.efilter)
	c:RegisterEffect(e2)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(80000442,0))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCountLimit(1)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c80000442.condition1)
	e3:SetTarget(c80000442.target)
	e3:SetOperation(c80000442.operation)
	c:RegisterEffect(e3)
	--cannot be target
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c80000442.tgcon)
	e4:SetValue(aux.imval1)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	--Activate1
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(80000117,1))
	e6:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(c80000442.condition)
	e6:SetCost(c80000442.cost1)
	e6:SetTarget(c80000442.tg)
	e6:SetOperation(c80000442.ac)
	c:RegisterEffect(e6)
	--cannot special summon
	local e10=Effect.CreateEffect(c)
	e10:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e10:SetType(EFFECT_TYPE_SINGLE)
	e10:SetCode(EFFECT_SPSUMMON_CONDITION)
	e10:SetValue(aux.synlimit)
	c:RegisterEffect(e10)  
end
function c80000442.condition1(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_TRAP) 
end
function c80000442.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c80000442.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)==0 then return end
	   Duel.Draw(tp,2,REASON_EFFECT)
end
function c80000442.tgfilter(c)
	return c:IsFaceup() and c:IsCode(80000441)
end
function c80000442.tgcon(e)
	return Duel.IsExistingMatchingCard(c80000442.tgfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,e:GetHandler())
end
function c80000442.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c80000442.matfilter1(c,syncard)
	return c:IsType(TYPE_TUNER) and (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and c:IsCanBeSynchroMaterial(syncard) and c:IsType(TYPE_SYNCHRO) and c:IsSetCard(0x2d0)
end
function c80000442.matfilter2(c,syncard)
	return c:IsNotTuner() and c:IsFaceup() and c:IsSetCard(0x2d0) and c:IsType(TYPE_SYNCHRO) and c:IsCanBeSynchroMaterial(syncard)
end
function c80000442.synfilter1(c,syncard,lv,g1,g2,g3)
	local f1=c.tuner_filter
	if c:IsHasEffect(EFFECT_HAND_SYNCHRO) then
		return g3:IsExists(c80000442.synfilter2,1,c,syncard,lv,g2,f1,c)
	else
		return g1:IsExists(c80000442.synfilter2,1,c,syncard,lv,g2,f1,c)
	end
end
function c80000442.synfilter2(c,syncard,lv,g2,f1,tuner1)
	local f2=c.tuner_filter
	if f1 and not f1(c) then return false end
	if f2 and not f2(tuner1) then return false end
	local mg=g2:Filter(c80000442.synfilter3,nil,f1,f2)
	Duel.SetSelectedCard(Group.FromCards(c,tuner1))
	return mg:CheckWithSumEqual(Card.GetSynchroLevel,lv,1,1,syncard)
end
function c80000442.synfilter3(c,f1,f2)
	return (not f1 or f1(c)) and (not f2 or f2(c))
end
function c80000442.syncon(e,c,tuner,mg)
	if c==nil then return true end
	local tp=c:GetControler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<-2 then return false end
	local g1=nil
	local g2=nil
	local g3=nil
	if mg then
		g1=mg:Filter(c80000442.matfilter1,nil,c)
		g2=mg:Filter(c80000442.matfilter2,nil,c)
		g3=g1:Clone()
	else
		g1=Duel.GetMatchingGroup(c80000442.matfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
		g2=Duel.GetMatchingGroup(c80000442.matfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
		g3=Duel.GetMatchingGroup(c80000442.matfilter1,tp,LOCATION_MZONE+LOCATION_HAND,LOCATION_MZONE,nil,c)
	end
	local pe=Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_SMATERIAL)
	local lv=c:GetLevel()
	if tuner then
		local f1=tuner.tuner_filter
		if not pe then
			return g1:IsExists(c80000442.synfilter2,1,tuner,c,lv,g2,f1,tuner)
		else
			return c80000442.synfilter2(pe:GetOwner(),c,lv,g2,f1,tuner)
		end
	end
	if not pe then
		return g1:IsExists(c80000442.synfilter1,1,nil,c,lv,g1,g2,g3)
	else
		return c80000442.synfilter1(pe:GetOwner(),c,lv,g1,g2,g3)
	end
end
function c80000442.synop(e,tp,eg,ep,ev,re,r,rp,c,tuner,mg)
	local g=Group.CreateGroup()
	local g1=nil
	local g2=nil
	local g3=nil
	if mg then
		g1=mg:Filter(c80000442.matfilter1,nil,c)
		g2=mg:Filter(c80000442.matfilter2,nil,c)
		g3=g1:Clone()
	else
		g1=Duel.GetMatchingGroup(c80000442.matfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
		g2=Duel.GetMatchingGroup(c80000442.matfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
		g3=Duel.GetMatchingGroup(c80000442.matfilter1,tp,LOCATION_MZONE+LOCATION_HAND,LOCATION_MZONE,nil,c)
	end
	local pe=Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_SMATERIAL)
	local lv=c:GetLevel()
	if tuner then
		g:AddCard(tuner)
		local f1=tuner.tuner_filter
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local tuner2=nil
		if not pe then
			local t2=g1:FilterSelect(tp,c80000442.synfilter2,1,1,tuner,c,lv,g2,f1,tuner)
			tuner2=t2:GetFirst()
		else
			tuner2=pe:GetOwner()
			Group.FromCards(tuner2):Select(tp,1,1,nil)
		end
		g:AddCard(tuner2)
		local f2=tuner2.tuner_filter
		local mg2=g2:Filter(c80000442.synfilter3,nil,f1,f2)
		Duel.SetSelectedCard(g)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local m3=mg2:SelectWithSumEqual(tp,Card.GetSynchroLevel,lv,1,1,c)
		g:Merge(m3)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local tuner1=nil
		if not pe then
			local t1=g1:FilterSelect(tp,c80000442.synfilter1,1,1,nil,c,lv,g1,g2,g3)
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
			t2=g3:FilterSelect(tp,c80000442.synfilter2,1,1,tuner1,c,lv,g2,f1,tuner1)
		else
			t2=g1:FilterSelect(tp,c80000442.synfilter2,1,1,tuner1,c,lv,g2,f1,tuner1)
		end
		local tuner2=t2:GetFirst()
		g:AddCard(tuner2)
		local f2=tuner2.tuner_filter
		local mg2=g2:Filter(c80000442.synfilter3,nil,f1,f2)
		Duel.SetSelectedCard(g)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local m3=mg2:SelectWithSumEqual(tp,Card.GetSynchroLevel,lv,1,1,c)
		g:Merge(m3)
	end
	c:SetMaterial(g)
	Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO)
end
function c80000442.condition(e)
	return Duel.GetLP(tp)<=Duel.GetLP(1-tp)-2000
end
function c80000442.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Recover(e:GetHandler(),1000,REASON_COST)
end
function c80000442.filter1(c,e,tp)
	return c:IsCode(80000444) 
end
function c80000442.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c80000442.filter1,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetChainLimit(aux.FALSE)
end
function c80000442.ac(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c80000442.filter1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)
	end
end