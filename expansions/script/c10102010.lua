--圣谕裁决者 蜜雪莉雅
function c10102010.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--SpecialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10102010,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,10102010)
	e1:SetCost(c10102010.spcost)
	e1:SetTarget(c10102010.sptg)
	e1:SetOperation(c10102010.spop)
	c:RegisterEffect(e1) 
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10102010,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,0x1e0)
	e2:SetCost(c10102010.descost)
	e2:SetTarget(c10102010.destg)
	e2:SetOperation(c10102010.desop)
	c:RegisterEffect(e2)   
	c10102010[c]=e2  
end
function c10102010.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function c10102010.filter1(c,e,tp,ft)
	return c:IsSetCard(0x9330) and c:IsType(TYPE_MONSTER) and (ft>0 or c:IsOnField())
		and Duel.IsExistingMatchingCard(c10102010.filter2,tp,LOCATION_DECK,0,1,nil,c:GetCode(),e,tp)
end
function c10102010.filter2(c,code,e,tp)
	return c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10102010.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.CheckReleaseGroupEx(tp,c10102010.filter1,1,nil,e,tp,ft)
	end
	local g=Duel.SelectReleaseGroup(tp,c10102010.filter1,1,1,nil,e,tp,ft)
	e:SetLabel(g:GetFirst():GetCode())
	Duel.Release(g,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c10102010.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c10102010.filter2,tp,LOCATION_DECK,0,1,1,nil,e:GetLabel(),e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c10102010.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c10102010.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(c10102010.desfilter,tp,0,LOCATION_ONFIELD,1,nil,c) and Duel.IsExistingMatchingCard(c10102004.thfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsType,tp,0,LOCATION_ONFIELD,1,1,nil,TYPE_SPELL+TYPE_TRAP)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c10102010.desfilter(c,rc)
	return rc:GetEquipGroup():GetCount()<=0 or not rc:GetEquipGroup():IsContains(c)
end
function c10102010.thfilter(c)
	return c:IsSetCard(0x9330) and c:IsAbleToHand()
end
function c10102010.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	   local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c10102010.thfilter),tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	   if g:GetCount()>0 then
		   Duel.SendtoHand(g,nil,REASON_EFFECT)
	   end
	end
end