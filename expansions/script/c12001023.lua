--六曜的霓虹丘儿
function c12001023.initial_effect(c)
   local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12001023,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(aux.SynCondition(nil,aux.NonTuner(c12001023.ntfilter),1,99))
	e1:SetTarget(aux.SynTarget(nil,aux.NonTuner(c12001023.ntfilter),1,99))
	e1:SetOperation(aux.SynOperation(nil,aux.NonTuner(c12001023.ntfilter),1,99))
	e1:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(12001023,1))
	e2:SetCondition(c12001023.syncon)
	e2:SetTarget(c12001023.syntg)
	e2:SetOperation(c12001023.synop)
	e2:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(12001023,3))
	e3:SetCategory(CATEGORY_NEGATE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCondition(c12001023.discon)
	e3:SetTarget(c12001023.distg)
	e3:SetOperation(c12001023.disop)
	c:RegisterEffect(e3)
end
function c12001023.ntfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xfb0) and c:IsCanBeSynchroMaterial()
end
function c12001023.matfilter1(c,syncard)
	return c:IsType(TYPE_PENDULUM) and c:GetSummonType()==SUMMON_TYPE_PENDULUM and c:IsNotTuner() and c:IsFaceup() and c:IsCanBeSynchroMaterial(syncard)
		and Duel.IsExistingMatchingCard(c12001023.matfilter2,0,LOCATION_MZONE,LOCATION_MZONE,1,c,syncard)
end
function c12001023.matfilter2(c,syncard)
	return c:IsNotTuner() and c:IsFaceup() and c:IsSetCard(0xfb0) and c:IsCanBeSynchroMaterial(syncard)
end
function c12001023.synfilter(c,syncard,lv,g2,minc)
	local tlv=c:GetSynchroLevel(syncard)
	if lv-tlv<=0 then return false end
	local g=g2:Clone()
	g:RemoveCard(c)
	return g:CheckWithSumEqual(Card.GetSynchroLevel,lv-tlv,minc-1,63,syncard)
end
function c12001023.syncon(e,c,tuner,mg)
	if c==nil then return true end
	if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
	local tp=c:GetControler()
	local ct=-Duel.GetLocationCount(tp,LOCATION_MZONE)
	local minc=2
	if minc<ct then minc=ct end
	local g1=nil
	local g2=nil
	if mg then
		g1=mg:Filter(c12001023.matfilter1,nil,c)
		g2=mg:Filter(c12001023.matfilter2,nil,c)
	else
		g1=Duel.GetMatchingGroup(c12001023.matfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
		g2=Duel.GetMatchingGroup(c12001023.matfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	end
	local pe=Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_SMATERIAL)
	local lv=c:GetLevel()
	if tuner then
		return c12001023.synfilter(tuner,c,lv,g2,minc)
	end
	if not pe then
		return g1:IsExists(c12001023.synfilter,1,nil,c,lv,g2,minc)
	else
		return c12001023.synfilter(pe:GetOwner(),c,lv,g2,minc)
	end
end
function c12001023.syntg(e,tp,eg,ep,ev,re,r,rp,chk,c,tuner,mg)
	local g=Group.CreateGroup()
	local g1=nil
	local g2=nil
	if mg then
		g1=mg:Filter(c12001023.matfilter1,nil,c)
		g2=mg:Filter(c12001023.matfilter2,nil,c)
	else
		g1=Duel.GetMatchingGroup(c12001023.matfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
		g2=Duel.GetMatchingGroup(c12001023.matfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	end
	local ct=-Duel.GetLocationCount(tp,LOCATION_MZONE)
	local minc=2
	if minc<ct then minc=ct end
	local pe=Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_SMATERIAL)
	local lv=c:GetLevel()
	if tuner then
		g:AddCard(tuner)
		g2:RemoveCard(tuner)
		local lv1=tuner:GetSynchroLevel(c)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local m2=g2:SelectWithSumEqual(tp,Card.GetSynchroLevel,lv-lv1,minc-1,63,c)
		g:Merge(m2)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local tuner=nil
		if not pe then
			local t1=g1:FilterSelect(tp,c12001023.synfilter,1,1,nil,c,lv,g2,minc)
			tuner=t1:GetFirst()
		else
			tuner=pe:GetOwner()
			Group.FromCards(tuner):Select(tp,1,1,nil)
		end
		tuner:RegisterFlagEffect(12001023,RESET_EVENT+0x1fe0000,0,1)
		g:AddCard(tuner)
		g2:RemoveCard(tuner)
		local lv1=tuner:GetSynchroLevel(c)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local m2=g2:SelectWithSumEqual(tp,Card.GetSynchroLevel,lv-lv1,minc-1,63,c)
		g:Merge(m2)
	end
	if g then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	else return false end
end
function c12001023.synop(e,tp,eg,ep,ev,re,r,rp,c,tuner,mg)
	local g=e:GetLabelObject()
	c:SetMaterial(g)
	Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO)
	g:DeleteGroup()
end
function c12001023.discon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsSetCard(0xfb0) and not re:GetHandler():IsCode(12001023) and Duel.IsChainNegatable(ev) and Duel.GetTurnPlayer()~=tp
end
function c12001023.distg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,1) end
end
function c12001023.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ng=Group.CreateGroup()
	for i=1,ev do
		local te=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
		local tc=te:GetHandler()
		ng:AddCard(tc)
	end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,ng,ng:GetCount(),0,0)
end
function c12001023.disop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanDiscardDeck(tp,1) then return end
	Duel.ConfirmDecktop(tp,1)
	local g=Duel.GetDecktopGroup(tp,1)
	local tc=g:GetFirst()
	if tc:IsSetCard(0xfb0) then
		Duel.DisableShuffleCheck()
		Duel.SendtoGrave(g,REASON_EFFECT+REASON_REVEAL)
		if not e:GetHandler():IsRelateToEffect(e) then return end
		for i=1,ev do
		local te=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
		if te:GetOwnerPlayer()~=tp then
			Duel.NegateActivation(i)
		end
		Duel.Destroy(e:GetHandler(),REASON_EFFECT)
	end
	else
		Duel.SendtoGrave(g,REASON_EFFECT+REASON_REVEAL)
		Duel.ShuffleDeck(nil)
end
end