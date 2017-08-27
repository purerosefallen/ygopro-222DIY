--幻层驱动 壳层
function c10130003.initial_effect(c)
	--Destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_POSITION)
	e1:SetDescription(aux.Stringid(10130003,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,10130003)
	e1:SetTarget(c10130003.destg)
	e1:SetOperation(c10130003.desop)
	c:RegisterEffect(e1) 
	--pos
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10130002,1))
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_HAND)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,0x1e0)
	e2:SetCountLimit(1,10130103)
	e2:SetCost(c10130003.poscost)
	e2:SetTarget(c10130003.postg)
	e2:SetOperation(c10130003.posop)
	c:RegisterEffect(e2)  
end
function c10130003.poscost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsPublic() end
	Duel.ConfirmCards(1-tp,c)
end
function c10130003.posfilter(c)
	return c:IsFacedown() and c:IsSetCard(0xa336)
end
function c10130003.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c10130003.posfilter(chkc) end
	if chk==0 then return Duel.IsExistingMatchingCard(c10130003.posfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEDOWN)
	local g=Duel.SelectTarget(tp,c10130003.posfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),tp,0)
end
function c10130003.posop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
		if tc and tc:IsRelateToEffect(e) then
		   Duel.ChangePosition(tc,POS_FACEUP_DEFENSE)
		end
end
function c10130003.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and chkc:IsDestructable() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c10130003.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc,c=Duel.GetFirstTarget(),e:GetHandler()
	if tc and tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
	   if not c:IsStatus(STATUS_DESTROY_CONFIRMED+STATUS_BATTLE_DESTROYED) and c:IsFaceup() and c:IsCanTurnSet() and Duel.SelectYesNo(tp,aux.Stringid(10130003,2)) then
		  Duel.ChangePosition(c,POS_FACEDOWN_DEFENSE)
		  Duel.ConfirmCards(1-tp,c)
	   end
		local sg=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_MZONE,0,nil)
			  if sg:GetCount()>0 then
				 Duel.BreakEffect()
				 Duel.ShuffleSetCard(sg)
			  end
	end
end