--最强的剑舞姬-莲·阿修贝尔
function c5200011.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x360),4,3,nil,nil,5)
	c:EnableReviveLimit()
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(c5200011.atkval)
	c:RegisterEffect(e1)
	--multi attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EXTRA_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c5200011.val)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,5200011)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCondition(c5200011.spcon)
	e3:SetTarget(c5200011.sptg)
	e3:SetOperation(c5200011.spop)
	c:RegisterEffect(e3)
end
function c5200011.atkval(e,c)
	return c:GetOverlayCount()*200
end
function c5200011.val(e,c)
	return c:GetOverlayCount()
end
function c5200011.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetOverlayCount()
	e:SetLabel(ct)
	return c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()~=tp
		and c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp and ct>0
end
function c5200011.spfilter(c,e,tp)
	return c:IsLevelBelow(4) and c:IsSetCard(0x360) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c5200011.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c5200011.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c5200011.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	local ct=e:GetLabel()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ct>ft then ct=ft end
	if Duel.IsPlayerAffectedByEffect(tp,5200011) then ct=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c5200011.spfilter,tp,LOCATION_GRAVE,0,1,ct,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),0,0)
end
function c5200011.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,5200011) then ft=1 end
	if ft<g:GetCount() then return end
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end