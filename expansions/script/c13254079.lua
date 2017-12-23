--禁忌飞球·地狱火
function c13254079.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,13254079+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c13254079.target)
	e1:SetOperation(c13254079.activate)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(13254079,0))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,23254079)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c13254079.descon)
	e2:SetTarget(c13254079.destg)
	e2:SetOperation(c13254079.desop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(13254079,0))
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,23254079)
	e3:SetCondition(c13254079.descon)
	e3:SetTarget(c13254079.destg)
	e3:SetOperation(c13254079.desop1)
	c:RegisterEffect(e3)
	
end
function c13254079.tgfilter(c)
	return c:IsCode(13254034) and c:IsAbleToGrave()
end
function c13254079.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c13254079.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,500)
end
function c13254079.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	e:GetHandler():RegisterFlagEffect(13254079,RESET_EVENT+0x1ec0000+RESET_PHASE+PHASE_END,0,1)
	local g=Duel.GetMatchingGroup(c13254079.tgfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>=1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g:Select(tp,1,99,nil)
		local ct=Duel.SendtoGrave(sg,REASON_EFFECT)
		if ct>0 then
			Duel.BreakEffect()
			Duel.Damage(1-tp,ct*500,REASON_EFFECT)
		end
	end
end
function c13254079.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(13254079)==0
end
function c13254079.filter1(c)
	return c:IsCode(13254034) and c:IsAbleToDeck()
end
function c13254079.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c13254079.filter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c13254079.filter1,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g1=Duel.SelectTarget(tp,c13254079.filter1,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g1,1,0,0)
end
function c13254079.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)~=1 then return end
	Duel.BreakEffect()
	local g1=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g1:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		sg1=g1:Select(tp,1,1,nil)
		local atk=sg1:GetFirst():GetAttack() or 0
		if Duel.Destroy(sg1,REASON_EFFECT)==1 and atk~=0
			then Duel.Recover(tp,atk,REASON_EFFECT)
		end
	end
end
function c13254079.desop1(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)~=1 then return end
	Duel.BreakEffect()
	local g1=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g1:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		sg1=g1:Select(tp,1,1,nil)
		local atk=sg1:GetFirst():GetAttack() or 0
		if Duel.Destroy(sg1,REASON_EFFECT)==1 and atk~=0
			then Duel.Recover(tp,atk,REASON_EFFECT)
		end
	end
end
