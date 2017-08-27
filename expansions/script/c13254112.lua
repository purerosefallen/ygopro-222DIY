--扭曲飞球·精神界
function c13254112.initial_effect(c)
	c:EnableCounterPermit(0x356)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_DRAW)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCondition(c13254112.addcon)
	e2:SetOperation(c13254112.addc)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetCondition(c13254112.iecon)
	e3:SetValue(c13254112.efilter)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCost(c13254112.spcost)
	e4:SetTarget(c13254112.sptg)
	e4:SetOperation(c13254112.spop)
	c:RegisterEffect(e4)
	
end
function c13254112.addcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and r==REASON_RULE 
end
function c13254112.addc(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x356,1)
end
function c13254112.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
function c13254112.iecon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetCounter(0x356)<3
end
function c13254112.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x356,3,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x356,3,REASON_COST)
end
function c13254112.spfilter(c,e,tp)
	return c:IsCode(13254043) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c13254112.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCountFromEx(tp)>0
		and Duel.IsExistingMatchingCard(c13254112.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_EXTRA)
end
function c13254112.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.GetLocationCountFromEx(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c13254112.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		local sc=g:GetFirst()
		Duel.SpecialSummon(sc,0,tp,tp,true,true,POS_FACEUP)
		sc:CompleteProcedure()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(4000)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		sc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(13254112,0))
		e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		sc:RegisterEffect(e2,true)
		local e3=Effect.CreateEffect(c)
		e3:SetDescription(aux.Stringid(13254112,1))
		e3:SetCategory(CATEGORY_DESTROY)
		e3:SetType(EFFECT_TYPE_QUICK_O)
		e3:SetCode(EVENT_FREE_CHAIN)
		e3:SetRange(LOCATION_MZONE)
		e3:SetHintTiming(0,0x1e0)
		e3:SetCost(c13254112.descost)
		e3:SetTarget(c13254112.destg)
		e3:SetOperation(c13254112.desop)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		sc:RegisterEffect(e3,true)
		--cannot target
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e4:SetRange(LOCATION_MZONE)
		e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e4:SetValue(1)
		e4:SetReset(RESET_EVENT+0x1fe0000)
		sc:RegisterEffect(e4,true)
		--indes
		local e5=e4:Clone()
		e5:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		sc:RegisterEffect(e5,true)
		local e6=e4:Clone()
		e6:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		sc:RegisterEffect(e6,true)
	end
end
function c13254112.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c13254112.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c13254112.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
