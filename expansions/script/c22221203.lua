--白泽球的补给
function c22221203.initial_effect(c)
	c:SetUniqueOnField(1,0,22221203)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--search
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(22221203,0))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_PREDRAW)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(c22221203.condition)
	e4:SetTarget(c22221203.target)
	e4:SetOperation(c22221203.operation)
	c:RegisterEffect(e4)
	--Draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22221203,1))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1)
	e1:SetCondition(c22221203.spcon)
	e1:SetTarget(c22221203.sptg)
	e1:SetOperation(c22221203.spop)
	c:RegisterEffect(e1)


end

c22221203.named_with_Shirasawa_Tama=1
function c22221203.IsShirasawaTama(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Shirasawa_Tama
end
function c22221203.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer() and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0
end
function c22221203.filter(c)
	return c22221203.IsShirasawaTama(c) and c:IsFaceup() and c:IsAbleToHand()
end
function c22221203.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_REMOVED) and c22221203.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c22221203.filter,tp,LOCATION_REMOVED,0,1,nil) end
	local dt=Duel.GetDrawCount(tp)
	if dt~=0 then
		e:SetLabel(1)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectTarget(tp,c22221203.filter,tp,LOCATION_REMOVED,0,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_DRAW_COUNT)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_PHASE+PHASE_DRAW)
		e1:SetValue(0)
		Duel.RegisterEffect(e1,tp)
	else e:SetLabel(0) end
end
function c22221203.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if e:GetLabel()==1 and e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c22221203.spcon(e,tp,eg,ep,ev,re,r,rp)
	local ec=eg:GetFirst()
	return eg:GetCount()==1 and ec:GetSummonPlayer()==tp and bit.band(ec:GetSummonType(),SUMMON_TYPE_RITUAL)==SUMMON_TYPE_RITUAL and c22221203.IsShirasawaTama(ec)
end
function c22221203.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c22221203.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return false end
	if not eg:GetFirst():IsLocation(LOCATION_MZONE) then return false end
	if Duel.SendtoHand(eg,nil,REASON_EFFECT) then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end

