--ps
function c10116002.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE+CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,10116002+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c10116002.cost)
	e1:SetTarget(c10116002.target)
	e1:SetOperation(c10116002.activate)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(10116002,ACTIVITY_CHAIN,aux.FALSE)
end

function c10116002.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(10116002,tp,ACTIVITY_CHAIN)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,0)
	e1:SetValue(aux.TRUE)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN)
	Duel.RegisterEffect(e1,tp)
end

function c10116002.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3331)
end

function c10116002.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c10116002.cfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,800)
end

function c10116002.activate(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(c10116002.cfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,ct,nil)
	if g:GetCount()>0 then
		local dc=Duel.Destroy(g,REASON_EFFECT)
		local tg=Duel.GetMatchingGroup(c10116002.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
		local sg=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
		if dc>=1 then Duel.Damage(1-tp,800,REASON_EFFECT) end
		if dc>=3 and tg:GetCount()>0 then
		  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		  local tgg=tg:Select(tp,1,1,nil)
		  Duel.SendtoHand(tgg,nil,REASON_EFFECT)
		  Duel.ConfirmCards(1-tp,tgg)
		end
		if dc>=5 and sg:GetCount()>0 then
		  Duel.SendtoGrave(sg,REASON_EFFECT)
		end
	end
end

function c10116002.thfilter(c)
	return c:IsSetCard(0x3331) and c:IsAbleToHand() 
end
