--口袋妖怪 果然翁
function c80000248.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c80000248.ffilter,2,true)  
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_BE_BATTLE_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c80000248.descon1)
	e2:SetTarget(c80000248.destg)
	e2:SetOperation(c80000248.desop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_BECOME_TARGET)
	e3:SetCondition(c80000248.descon2)
	c:RegisterEffect(e3)  
	--salvage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(60316373,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCost(c80000248.cost)
	e1:SetTarget(c80000248.target)
	e1:SetOperation(c80000248.operation)
	c:RegisterEffect(e1)
end
function c80000248.ffilter(c)
	return c:IsSetCard(0x2d0) and c:IsRace(RACE_SPELLCASTER)
end
function c80000248.tgfilter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsControler(tp)
end
function c80000248.descon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c80000248.tgfilter,1,nil,tp)
end
function c80000248.descon2(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and eg:IsExists(c80000248.tgfilter,1,nil,tp)
end
function c80000248.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil)
		 and not e:GetHandler():IsStatus(STATUS_CHAINING) end
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c80000248.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_ONFIELD,nil)
	Duel.Destroy(g,REASON_EFFECT)
end
function c80000248.filter(c)
	return c:IsCode(80000249) and c:IsAbleToHand()
end
function c80000248.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c80000248.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c80000248.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c80000248.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c80000248.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c80000248.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end