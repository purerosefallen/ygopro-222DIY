--命运-冠位指定
function c21401130.initial_effect(c)
	c:EnableCounterPermit(0xf0f)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c21401130.target)
	e1:SetOperation(c21401130.activate)
	c:RegisterEffect(e1)
    --add counter
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCondition(c21401130.ctcon)
	e4:SetOperation(c21401130.ctop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)
	--Remove counter replace
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_RCOUNTER_REPLACE+0xf0f)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCondition(c21401130.rcon)
	e4:SetOperation(c21401130.rop)
	c:RegisterEffect(e4)
	--Draw
	local e7=Effect.CreateEffect(c)
	e7:SetCategory(CATEGORY_DRAW)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e7:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e7:SetCode(EVENT_CUSTOM+0xf0f)
	e7:SetRange(LOCATION_FZONE)
	e7:SetCondition(c21401130.drcon)
    e7:SetOperation(c21401130.drop)
	c:RegisterEffect(e7)
end
function c21401130.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>2 end
end
function c21401130.filter(c)
	return c:IsSetCard(0xf00) and c:IsType(TYPE_PENDULUM)
end
function c21401130.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<3 then return end
	local g=Duel.GetDecktopGroup(tp,3)
	Duel.ConfirmCards(tp,g)
	if not Duel.CheckLocation(tp,LOCATION_SZONE,6) and not Duel.CheckLocation(tp,LOCATION_SZONE,7) then return end
	if g:IsExists(c21401130.filter,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(21401130,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(21401130,1))
		local sg=g:FilterSelect(tp,c21401130.filter,1,1,nil)
		local tc=sg:GetFirst()
		if tc then
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		end
	else Duel.ShuffleDeck(tp)
	end
end
function c21401130.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xf00)
end
function c21401130.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c21401130.cfilter,1,nil)
end
function c21401130.ctop(e,tp,eg,ep,ev,re,r,rp)
	local ct=eg:FilterCount(c21401130.cfilter,nil)
	if ct>0 then
		e:GetHandler():AddCounter(0xf0f,ct)
	end
end
function c21401130.rcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_COST)~=0 and ep==e:GetOwnerPlayer() and e:GetHandler():GetCounter(0xf0f)>=ev
end
function c21401130.rop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RemoveCounter(ep,0xf0f,ev,REASON_EFFECT)
end
function c21401130.cfilter2(c)
	return (c:IsSetCard(0xf00) or c:IsSetCard(0xf0b))and c:IsAbleToHand()
end
function c21401130.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:GetFirst():IsControler(tp) and eg:GetFirst():IsType(TYPE_MONSTER)
end
function c21401130.drop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Draw(tp,1,REASON_EFFECT)
end