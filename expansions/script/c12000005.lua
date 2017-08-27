--奇迹糕点 糕点神龙
function c12000005.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,12000005)
	e1:SetCondition(c12000005.descon)
	e1:SetTarget(c12000005.destg)
	e1:SetOperation(c12000005.desop)
	c:RegisterEffect(e1)
	--attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SET_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c12000005.atkval)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCost(c12000005.thcost)
	e4:SetTarget(c12000005.thtg)
	e4:SetOperation(c12000005.thop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_REMOVE)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCountLimit(1,12000005)
	e5:SetCondition(c12000005.rthcon)
	e5:SetTarget(c12000005.rthtg)
	e5:SetOperation(c12000005.rthop)
	c:RegisterEffect(e5)
	
end
function c12000005.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xfbe)
end
function c12000005.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c12000005.cfilter,tp,LOCATION_SZONE,0,1,nil)
end
function c12000005.desfilter(c)
	return c:IsType(TYPE_TOKEN)
end
function c12000005.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tk=Duel.GetMatchingGroup(c12000005.desfilter,tp,LOCATION_MZONE,0,nil)
	local tkc=tk:GetCount()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if tkc>3 then tkc=3 end
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsType(TYPE_TOKEN) end
	if chk==0 then return ft>-tkc and Duel.IsExistingTarget(c12000005.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,3,nil) end
	local g=Group.CreateGroup()
	if ft>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		g=Duel.SelectTarget(tp,c12000005.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,3,3,nil)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		g=Duel.SelectTarget(tp,c12000005.desfilter,tp,LOCATION_MZONE,0,1,tkc,nil)
		if g:GetCount()<3 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local sg=Duel.SelectTarget(tp,c12000005.desfilter,tp,0,LOCATION_MZONE,1,3-g:GetCount(),nil)
			g:Merge(sg)
		end
	end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c12000005.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 then
		if Duel.Destroy(tg,REASON_EFFECT)==3 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c12000005.atkval(e,c)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,c:GetControler(),LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	return g:GetCount()*500
end
function c12000005.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c12000005.thfilter(c)
	return c:IsSetCard(0xfbe) and c:IsAbleToHand()
end
function c12000005.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12000005.thfilter,tp,LOCATION_REMOVED,0,2,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function c12000005.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c12000005.thfilter,tp,LOCATION_REMOVED,0,2,2,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c12000005.cfilter1(c,tp)
	return c:IsSetCard(0xfbe) and c:IsPreviousLocation(LOCATION_GRAVE) and c:GetPreviousControler()==tp and c:IsFaceup()
end
function c12000005.rthcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c12000005.cfilter1,1,nil,tp)
end
function c12000005.rthtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c12000005.rthop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
	end
end
