--圣谕法师 安德鲁
function c10102003.initial_effect(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10102003,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,10102003)
	e1:SetCost(c10102003.descost)
	e1:SetTarget(c10102003.destg)
	e1:SetOperation(c10102003.desop)
	c:RegisterEffect(e1) 
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetDescription(aux.Stringid(10102003,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,10102103)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c10102003.thcost)
	e2:SetTarget(c10102003.thtg)
	e2:SetOperation(c10102003.thop)
	c:RegisterEffect(e2) 
	c10102003[c]=e2  
end
function c10102003.filter(c,id,ec)
	return c:IsSetCard(0x9330) and c:GetTurnID()==id and not c:IsReason(REASON_RETURN) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER) and c~=ec
end
function c10102003.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc,ec)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c10102003.filter(chkc,Duel.GetTurnCount()) and chkc~=e:GetHandler() and chkc~=ec end
	if chk==0 then return Duel.IsExistingTarget(c10102003.filter,tp,LOCATION_GRAVE,0,1,e:GetHandler(),Duel.GetTurnCount(),ec) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c10102003.filter,tp,LOCATION_GRAVE,0,1,2,e:GetHandler(),Duel.GetTurnCount(),nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c10102003.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c10102003.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c10102003.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupEx(tp,Card.IsType,1,nil,TYPE_MONSTER) end
	local g=Duel.SelectReleaseGroupEx(tp,Card.IsType,1,1,nil,TYPE_MONSTER)
	Duel.Release(g,REASON_COST)
end
function c10102003.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c10102003.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end