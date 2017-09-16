--ps
function c10116002.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1e0)
	e1:SetCountLimit(1,10116002+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c10116002.condition)
	e1:SetTarget(c10116002.target)
	e1:SetOperation(c10116002.activate)
	c:RegisterEffect(e1)  
end
function c10116002.confilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3331)
end
function c10116002.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c10116002.confilter,tp,LOCATION_MZONE,0,3,nil) and Duel.GetFlagEffect(tp,10116002)<=0
end
function c10116002.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc~=e:GetHandler() end
	local c=e:GetHandler()
	local b1=Duel.IsPlayerCanDraw(tp,1)
	local b2=Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c)
	local b3=Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_EXTRA,1,nil)
	if chk==0 then return b1 or b2 or b3 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
	local ops={}
	local opval={}
	local off=1
	if b1 then
		ops[off]=aux.Stringid(10116002,1)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(10116002,2)
		opval[off-1]=2
		off=off+1
	end
	if b3 then
		ops[off]=aux.Stringid(10116002,3)
		opval[off-1]=3
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	local sel=opval[op]
	e:SetLabel(sel)
	if sel==1 then
	  e:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	  e:SetCategory(CATEGORY_HANDES+CATEGORY_DRAW)
	  Duel.SetTargetPlayer(tp)
	  Duel.SetTargetParam(2)
	  Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	  Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
	elseif sel==2 then
	  e:SetCategory(CATEGORY_DESTROY)
	  e:SetProperty(EFFECT_FLAG_CARD_TARGET)
	  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	  local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,c)
	  Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	else
	  e:SetCategory(CATEGORY_REMOVE)
	  e:SetProperty(0)
	  Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_EXTRA)
	end
end
function c10116002.activate(e,tp,eg,ep,ev,re,r,rp)
	local sel=e:GetLabel()
	if sel==1 then
	   local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	   if Duel.Draw(p,d,REASON_EFFECT)==2 then
		  Duel.ShuffleHand(p)
		  Duel.BreakEffect()
		  Duel.DiscardHand(p,nil,1,1,REASON_EFFECT+REASON_DISCARD)
	   end
	elseif se1==2 then
	   local tc=Duel.GetFirstTarget()
	   if tc:IsRelateToEffect(e) then
		  Duel.Destroy(tc,REASON_EFFECT)
	   end
	else
	   local rg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_EXTRA,nil)
	   if rg:GetCount()>0 then
		  Duel.ConfirmCards(tp,rg)
		  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		  local g=rg:Select(tp,1,1,nil)
		  Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	   end
	end
end