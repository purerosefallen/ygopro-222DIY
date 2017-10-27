--エニード
function c17060899.initial_effect(c)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(17060899,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetTargetRange(1,0)
	e1:SetCondition(c17060899.splimcon)
	e1:SetTarget(c17060899.splimit)
	c:RegisterEffect(e1)
	--SP SUMMON
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(17060899,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,17060899)
	e2:SetCondition(c17060899.spcon)
	e2:SetTarget(c17060899.sptg)
	e2:SetOperation(c17060899.spop)
	c:RegisterEffect(e2)
	--Activate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(17060899,2))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c17060899.retg)
	e3:SetOperation(c17060899.reop)
	c:RegisterEffect(e3)
	--SP SUMMON
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(17060899,3))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,17060899+100)
	e4:SetCondition(c17060899.rpcon)
	e4:SetTarget(c17060899.rptg)
	e4:SetOperation(c17060899.rpop)
	c:RegisterEffect(e4)
end
c17060899.is_named_with_Opera_type=1
function c17060899.IsOpera_type(c)
	local m=_G["c"..c:GetCode()]
	return m and m.is_named_with_Opera_type
end
function c17060899.splimcon(e)
	return not e:GetHandler():IsForbidden()
end
function c17060899.splimit(e,c,tp,sumtp,sumpos)
	return not c:IsType(TYPE_PENDULUM) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c17060899.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
function c17060899.spfilter(c,e,tp)
	return c:GetLevel()==1 and c:IsType(TYPE_PENDULUM) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c17060899.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c17060899.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c17060899.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c17060899.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c17060899.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToRemove()
end
function c17060899.retg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c17060899.filter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c17060899.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c17060899.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c17060899.reop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
function c17060899.rpcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c17060899.rpfilter(c,e,tp)
	return (c17060899.IsOpera_type(c) and c:IsType(TYPE_RITUAL) and not c:IsCode(17060899)) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)
end
function c17060899.rptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCountFromEx(tp)>0 
		and Duel.IsExistingMatchingCard(c17060899.rpfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c17060899.rpop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCountFromEx(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c17060899.rpfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
	end
end