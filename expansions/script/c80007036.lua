--ex 笑你全家的幼女
function c80007036.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,6,6,c80007036.ovfilter,aux.Stringid(80007036,0),3,c80007036.xyzop)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(80007036,1))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCondition(c80007036.thcon)
	e1:SetTarget(c80007036.target)
	e1:SetOperation(c80007036.operation)
	c:RegisterEffect(e1)  
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(1,0)
	e2:SetCondition(c80007036.splimcon)
	e2:SetTarget(c80007036.splimit)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EFFECT_CANNOT_SUMMON)
	c:RegisterEffect(e4)  
	--spsummon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(80007036,2))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCost(c80007036.cost)
	e5:SetTarget(c80007036.sptg)
	e5:SetOperation(c80007036.spop)
	c:RegisterEffect(e5)
end
c80007036.pendulum_level=6
function c80007036.cfilter(c)
	return c:IsSetCard(0x2d9) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDiscardable()
end
function c80007036.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x2d9) and c:IsType(TYPE_FUSION+TYPE_XYZ+TYPE_SYNCHRO)
end
function c80007036.xyzop(e,tp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c80007036.cfilter,tp,LOCATION_HAND,0,2,nil) end
	Duel.DiscardHand(tp,c80007036.cfilter,2,2,REASON_COST+REASON_DISCARD)
end
function c80007036.splimcon(e)
	return not e:GetHandler():IsForbidden()
end
function c80007036.splimit(e,c,tp,sumtp,sumpos)
	return not c:IsSetCard(0x2d9)
end
function c80007036.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_PENDULUM
end
function c80007036.filter(c,e,tp)
	return c:IsSetCard(0x2d9) and not c:IsCode(80007036) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c80007036.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c80007036.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c80007036.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c80007036.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)
	end
end
function c80007036.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c80007036.filter1(c)
	return c:IsSetCard(0x2d9) and c:IsAbleToHand()
end
function c80007036.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c80007036.filter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c80007036.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c80007036.filter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end