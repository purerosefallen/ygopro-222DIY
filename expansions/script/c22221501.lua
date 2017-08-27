--白泽球私塾
function c22221501.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c22221501.activate)
	c:RegisterEffect(e1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetRange(LOCATION_FZONE)
	e1:SetOperation(c22221501.atkop)
	c:RegisterEffect(e1)
	--salvage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22221501,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c22221501.thcon)
	e2:SetTarget(c22221501.thtg)
	e2:SetOperation(c22221501.thop)
	c:RegisterEffect(e2)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22221501,2))
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c22221501.drtg)
	e2:SetOperation(c22221501.drop)
	c:RegisterEffect(e2)
end
c22221501.named_with_Shirasawa_Tama=1
function c22221501.IsShirasawaTama(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Shirasawa_Tama
end
function c22221501.filter(c)
	return c:IsAbleToHand() and c22221501.IsShirasawaTama(c) and c:IsType(TYPE_MONSTER)
end
function c22221501.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c22221501.filter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(22221501,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c22221501.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not re:GetHandler() then return end
	if re:GetHandler():GetControler() ~= c:GetControler() and c:IsOnField() and c:IsFaceup() then
		local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
		tc=g:GetFirst()
		while tc do
			local atk=tc:GetBaseAttack()
			local def=tc:GetBaseDefense()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_BASE_ATTACK)
			e1:SetValue(atk-300)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_SET_BASE_DEFENSE)
			e2:SetValue(def-100)
			tc:RegisterEffect(e2)
			tc=g:GetNext()
		end
	end
end
function c22221501.ccfilter(c)
	return bit.band(c:GetSummonType(),SUMMON_TYPE_RITUAL)==SUMMON_TYPE_RITUAL and c22221501.IsShirasawaTama(c)
end
function c22221501.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c22221501.ccfilter,1,nil)
end
function c22221501.thfilter(c,e,tp)
	return c:IsControler(tp) and c:IsAbleToHand() and c:IsCanBeEffectTarget(e)
end
function c22221501.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tc=eg:GetFirst()
	local mat=tc:GetMaterial()
	if chkc then return mat:IsContains(chkc) and c22221501.thfilter(chkc,e,tp) end
	if chk==0 then return mat:IsExists(c22221501.thfilter,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=mat:FilterSelect(tp,c22221501.thfilter,1,1,nil,e,tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c22221501.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c22221501.cfilter(c)
	return c22221501.IsShirasawaTama(c) and c:IsAbleToDeck() and c:IsFaceup()
end
function c22221501.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp) and Duel.IsExistingMatchingCard(c22221501.cfilter,tp,LOCATION_REMOVED,0,1,nil) end
end
function c22221501.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.SelectMatchingCard(tp,c22221501.cfilter,tp,LOCATION_REMOVED,0,1,9,nil)
	if Duel.SendtoDeck(g,nil,2,REASON_EFFECT)>0 then
		Duel.ShuffleDeck(tp)
		Duel.Draw(tp,math.floor(g:GetCount()/3),REASON_EFFECT)
	end
end