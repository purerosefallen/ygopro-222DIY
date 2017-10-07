--Solid 零一八
function c22241001.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,222410011+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c22241001.target)
	e1:SetOperation(c22241001.operation)
	c:RegisterEffect(e1)
	--Release-
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22241001,2))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_RELEASE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,222410012)
	e2:SetCondition(c22241001.adcon)
	e2:SetTarget(c22241001.adtg)
	e2:SetOperation(c22241001.adop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e3)
end
c22241001.named_with_Solid=1
function c22241001.IsSolid(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Solid
end
function c22241001.desfilter(c)
	return bit.band(c:GetType(),0x81)==0x81
end
function c22241001.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and c22241001.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c22241001.desfilter,tp,LOCATION_GRAVE,0,3,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c22241001.desfilter,tp,LOCATION_GRAVE,0,3,3,nil)
	if g:FilterCount(Card.IsAbleToDeck,nil)==3 and Duel.IsPlayerCanDraw(tp,2) and Duel.SelectYesNo(tp,aux.Stringid(22241001,0)) then 
		e:SetLabel(1)
		e:SetCategory(CATEGORY_DRAW)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,g,3,0,0)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	elseif Duel.GetLocationCount(tp,LOCATION_SZONE)>2 and Duel.SelectYesNo(tp,aux.Stringid(22241001,1)) then
		e:SetLabel(2)
	else
		e:SetLabel(0)
	end
end
function c22241001.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()~=3 then return end
	if e:GetLabel()==1 then
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		Duel.Draw(tp,2,REASON_EFFECT)
	elseif e:GetLabel()==2 and Duel.GetLocationCount(tp,LOCATION_SZONE)>2 then
		local c=g:GetFirst()
		while c do
			Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fc0000)
			e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
			c:RegisterEffect(e1)
			c=g:GetNext()
		end
	end
end
function c22241001.adcon(e,tp,eg,ep,ev,re,r,rp,chk)
	return bit.band(e:GetHandler():GetReason(),REASON_RELEASE)~=0
end
function c22241001.adtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>2 end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_DECK)
end
function c22241001.filter(c)
	return c:IsReleasableByEffect() and c22241001.IsSolid(c)
end
function c22241001.adop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<3 then return end
	Duel.ConfirmDecktop(tp,3)
	local g=Duel.GetDecktopGroup(tp,3)
	local eg=g:Filter(c22241001.filter,nil)
	if eg:GetCount()>0 then
		local sg=eg:Select(tp,1,1,nil)
		Duel.SendtoGrave(sg,REASON_RELEASE+REASON_EFFECT)
	end
	Duel.ShuffleDeck(tp)
end


