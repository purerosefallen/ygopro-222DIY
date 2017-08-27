--★先輩魔法少女 巴マミ
function c114000109.initial_effect(c)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(c114000109.atkval)
	c:RegisterEffect(e1)
	--search
	e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetTarget(c114000109.schtg)
	e2:SetOperation(c114000109.schop)
	c:RegisterEffect(e2)
end
--atk up function
function c114000109.filter(c)
	return c:IsFaceup() and ( c:IsSetCard(0x221) or c:IsCode(114000231) )
end
function c114000109.atkval(e,c)
	local c=e:GetHandler()
	return Duel.GetMatchingGroupCount(c114000109.filter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,c)*300
end
--search function
function c114000109.sfilter(c)
	return c:IsSetCard(0xcabb) 
	and c:IsAbleToHand()
end
function c114000109.schtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c114000109.sfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c114000109.schop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c114000109.sfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end