--圣诞游玩 奇犽
function c50000072.initial_effect(c)
	--1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(50000072,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,50000072)
	e1:SetCondition(c50000072.spcon)
	e1:SetCost(c50000072.spcost)
	e1:SetTarget(c50000072.sptg)
	e1:SetOperation(c50000072.spop)
	c:RegisterEffect(e1)
	--2
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetDescription(aux.Stringid(50000072,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,50000072)
	e2:SetTarget(c50000072.thtg)
	e2:SetOperation(c50000072.thop)
	c:RegisterEffect(e2)
	--3
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCondition(c50000072.indcon)
	e3:SetOperation(c50000072.indop)
	c:RegisterEffect(e3)
end
--1
function c50000072.spfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x50c)
end
function c50000072.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c50000072.spfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c50000072.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function c50000072.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c50000072.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
--2
function c50000072.thfilter(c)
	return c:IsSetCard(0x50c) and not c:IsCode(50000072) and c:IsAbleToHand()
end
function c50000072.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c50000072.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c50000072.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c50000072.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c50000072.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
--3
function c50000072.indcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_FUSION 
end
function c50000072.indop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(50000072,2))
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	rc:RegisterEffect(e1)
end