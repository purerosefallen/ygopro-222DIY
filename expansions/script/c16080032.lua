--黑莲与枭
function c16080032.initial_effect(c)
  --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_CONTROL+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c16080032.target)
	e1:SetOperation(c16080032.activate)
	c:RegisterEffect(e1)  
end
function c16080032.filter(c)
	return c:IsControlerCanBeChanged() and c:IsLevelBelow(6) or c:IsRankBelow(6)
end
function c16080032.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_MZONE and chkc:GetControler()~=tp and chkc:filter() end
	if chk==0 then return Duel.IsExistingTarget(c16080032.filter,tp,0,LOCATION_MZONE,1,nil) and Duel.IsPlayerCanDraw(1-tp,2) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,c16080032.filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c16080032.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then Duel.GetControl(tc,tp,RESET_EVENT+0x1fc0000,1)
	end
	if tc:IsOnField() then  
	Duel.Draw(1-tp,2,REASON_EFFECT)
	end
end