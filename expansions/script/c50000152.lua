--幻星－扑克
function c50000152.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(50000152,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,50000152)
	e1:SetCost(c50000152.spcost)
	e1:SetTarget(c50000152.sptg)
	e1:SetOperation(c50000152.spop)
	c:RegisterEffect(e1)
	--To Hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(50000152,1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCountLimit(1,500001521)
	e2:SetCondition(c50000152.drcon)
	e2:SetTarget(c50000152.drtg)
	e2:SetOperation(c50000152.drop)
	c:RegisterEffect(e2)
end
c50000152.is_named_with_Kensei=1
function c50000152.IsKensei(c)
	local code=c:GetCode()
	local mt=_G["c"..code]
	if not mt then
		_G["c"..code]={}
		if pcall(function() dofile("expansions/script/c"..code..".lua") end) or pcall(function() dofile("script/c"..code..".lua") end) then
			mt=_G["c"..code]
			_G["c"..code]=nil
		else
			_G["c"..code]=nil
			return false
		end
	end
	return mt and mt.is_named_with_Kensei
end
function c50000152.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD,e:GetHandler())
end
function c50000152.filter(c)
	return c:IsFaceup() and c50000152.IsKensei(c) and c:IsType(TYPE_MONSTER)
end
function c50000152.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(tp) and c50000152.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c50000152.filter,tp,LOCATION_ONFIELD,0,1,nil) and Duel.GetMZoneCount(tp)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c50000152.filter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c50000152.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local num=Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	if c:IsRelateToEffect(e) and num==0
		and Duel.GetMZoneCount(tp)<=0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
		Duel.SendtoGrave(c,REASON_RULE)
	end
	if num>0 then
		Duel.BreakEffect()
		local tc=Duel.GetFirstTarget()
		Duel.Destroy(tc,REASON_EFFECT)
	end
end

function c50000152.drcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c50000152.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c50000152.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end