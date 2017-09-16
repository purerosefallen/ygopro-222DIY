--七曜-水符『水精公主』
function c2170703.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,2170703+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c2170703.sdcon)
	e1:SetTarget(c2170703.rectg)
	e1:SetOperation(c2170703.activate)
	c:RegisterEffect(e1)
	--tohand
	--local e2=Effect.CreateEffect(c)
	--e2:SetDescription(aux.Stringid(2170703,1))
	--e2:SetCategory(CATEGORY_TOHAND)
	--e2:SetType(EFFECT_TYPE_IGNITION)
	--e2:SetRange(LOCATION_GRAVE)
	--e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	--e2:SetCost(c2170703.thcost)
	--e2:SetTarget(c2170703.thtg)
	--e2:SetOperation(c2170703.thop)
	--c:RegisterEffect(e2)
end
function c2170703.filter(c)
	return c:IsSetCard(0x211) and c:IsFaceup() and c:IsType(TYPE_SPELL)
end
function c2170703.sdcon(e)
	return Duel.IsExistingMatchingCard(c2170704.sdfilter,e:GetHandlerPlayer(),LOCATION_SZONE,0,1,e:GetHandler())
end
function c2170703.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local q=Duel.GetMatchingGroupCount(c2170703.filter,e:GetHandler():GetControler(),LOCATION_SZONE,0,nil)*500
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(q)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,q)
end
function c2170703.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
	Duel.BreakEffect()
	Duel.Draw(tp,1,REASON_EFFECT)
end
--function c2170703.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	--if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	--Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
--end
--function c2170703.filter(c)
	--return c:IsSetCard(0x211) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
--end
--function c2170703.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	--if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c2170703.filter(chkc) end
	--if chk==0 then return Duel.IsExistingTarget(c2170703.filter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	--Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	--local g=Duel.SelectTarget(tp,c2170703.filter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	--Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
--end
--function c2170703.thop(e,tp,eg,ep,ev,re,r,rp)
	--local tc=Duel.GetFirstTarget()
	--if tc:IsRelateToEffect(e) then
		--Duel.SendtoHand(tc,nil,REASON_EFFECT)
	--end
--end