--Caster 美狄亚
function c21401106.initial_effect(c)
	c:EnableCounterPermit(0xf0f)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCost(c21401106.spcost)
	e1:SetTarget(c21401106.sptg)
	e1:SetOperation(c21401106.spop)
	c:RegisterEffect(e1)
	--add counter
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21401106,2))
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c21401106.addcost)
	e2:SetTarget(c21401106.addtg)
	e2:SetOperation(c21401106.addop)
	c:RegisterEffect(e2)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(21401106,3))
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCountLimit(1)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c21401106.negcost)
	e3:SetTarget(c21401106.negtg)
	e3:SetOperation(c21401106.negop)
	c:RegisterEffect(e3)
end
function c21401106.filter(c,e,tp)
	return c:IsSetCard(0xf00) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:GetLevel()==2
end
function c21401106.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
    Duel.SendtoExtraP(e:GetHandler(),tp,REASON_COST)
end
function c21401106.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21401106.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c21401106.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(21401106,0))
	local g=Duel.SelectMatchingCard(tp,c21401106.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c21401106.costfilter(c)
	return c:IsSetCard(0xf0b) and c:IsDiscardable()
end
function c21401106.addcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21401106.costfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,c21401106.costfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c21401106.addtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,3,0,0xf0f)
end
function c21401106.addop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		e:GetHandler():AddCounter(0xf0f,3)
	end
end
function c21401106.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0xf0f,3,REASON_COST) end
	local c1=e:GetHandler():GetCounter(0xf0f)
	e:GetHandler():RemoveCounter(tp,0xf0f,3,REASON_COST)
	local c2=e:GetHandler():GetCounter(0xf0f)
	if c1==c2+3 then
	Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+0xf0f,e,0,tp,0,0)
	end
end
function c21401106.negfilter(c)
	return c:IsFaceup() and not c:IsType(TYPE_NORMAL)
end
function c21401106.negtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsOnField() and c21401106.negfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c21401106.negfilter,tp,LOCATION_ONFIELD,0,1,c,c) end
    Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(21401106,1))
	local g=Duel.SelectTarget(tp,c21401106.negfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,c,c)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c21401106.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsFaceup() and c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		c:SetCardTarget(tc)
		tc:RegisterFlagEffect(21401106,RESET_EVENT+0x1fe0000,0,0)
		--indes
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
		e1:SetCondition(c21401106.indcon)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE_EFFECT)
		e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
		e1:SetCondition(c21401106.indcon)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
	end
end
function c21401106.indcon(e)
	return e:GetOwner():IsHasCardTarget(e:GetHandler())
end