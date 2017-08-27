--口袋妖怪 向尾喵
function c80000031.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(80000031,0))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,80000031)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c80000031.thtg)
	e1:SetOperation(c80000031.thop)
	c:RegisterEffect(e1)
	--salvage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(80000031,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1)
	e2:SetCondition(c80000031.thcon)
	e2:SetTarget(c80000031.tt)
	e2:SetOperation(c80000031.tp)
	c:RegisterEffect(e2)
	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(c80000031.value)
	c:RegisterEffect(e3)
--synchro limit
	local e13=Effect.CreateEffect(c)
	e13:SetType(EFFECT_TYPE_SINGLE)
	e13:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e13:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e13:SetValue(c80000031.synlimit)
	c:RegisterEffect(e13) 
end
function c80000031.synlimit(e,c)
	if not c then return false end
	return not c:IsSetCard(0x2d0)
end
function c80000031.thfilter(c)
	return c:IsSetCard(0x2d0) and c:IsAbleToRemove()
end
function c80000031.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c80000031.thfilter,tp,LOCATION_DECK,0,3,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,LOCATION_DECK)
end
function c80000031.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_DECK,0,nil,0x2d0)
	if g:GetCount()>=3 then
		Duel.Hint(HINT_SELECTMSG,tp,CATEGORY_REMOVE)
		local sg=g:Select(tp,3,3,nil)
		Duel.ConfirmCards(1-tp,sg)
		Duel.ShuffleDeck(tp)
		Duel.Hint(HINT_SELECTMSG,1-tp,CATEGORY_REMOVE)
		local tg=sg:Select(1-tp,1,1,nil)
		local tc=tg:GetFirst()
		if tc:IsAbleToRemove() then Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)  
		else Duel.Remove(tc,POS_FACEUP,REASON_EFFECT) 
end
	end
end
function c80000031.thcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetPreviousLocation(),LOCATION_ONFIELD)>0
end
function c80000031.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x2d0) and c:IsAbleToHand()
end
function c80000031.tt(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_REMOVED) and c80000031.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c80000031.filter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c80000031.filter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c80000031.tp(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c80000031.afilter(c)
	return c:IsFaceup() and c:IsSetCard(0x2d0)
end
function c80000031.value(e,c)
	return Duel.GetMatchingGroupCount(c80000031.afilter,c:GetControler(),LOCATION_REMOVED,LOCATION_REMOVED,nil)*200
end