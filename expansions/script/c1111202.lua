--灵都·奈河奈何
function c1111202.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c1111202.tg2)
	e2:SetValue(c1111202.filter2)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,1111202) 
	e3:SetTarget(c1111202.tg3)
	e3:SetOperation(c1111202.op3)
	c:RegisterEffect(e3)
--
end
--
c1111202.named_with_Ld=1
function c1111202.IsLd(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Ld
end
function c1111202.IsLq(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Lq
end
--
function c1111202.filter2(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:IsActiveType(TYPE_MONSTER)
end
function c1111202.tgfilter2(c)
	return c:IsFaceup() and c1111202.IsLd(c) and c:IsControler(tp) and c:IsType(TYPE_MONSTER)
end
function c1111202.tg2(e,c)
	local g=Duel.GetMatchingGroup(c1111202.tgfilter2,c:GetControler(),LOCATION_MZONE,0,nil)
	return g
end
--
function c1111202.tfilter3(c)
	return c:IsAbleToRemove()
end
function c1111202.tg3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c1111202.tfilter1,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,LOCATION_GRAVE)
end
--
function c1111202.ofilter3x1(c)
	return c:IsFaceup() and c:IsAbleToGrave() and c:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_SPELL)
end
function c1111202.ofilter3x2(c)
	return c:IsSSetable() and c1111202.IsLq(c)
end
function c1111202.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,c1111202.tfilter3,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
		if g:GetCount()>0 then
			if Duel.Remove(g,POS_FACEUP,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(c1111202.ofilter3x1,tp,LOCATION_ONFIELD,0,1,nil) and Duel.IsExistingMatchingCard(c1111202.ofilter3x2,tp,LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(1111202,0)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
				local g=Duel.SelectMatchingCard(tp,c1111202.ofilter3x1,tp,LOCATION_ONFIELD,0,1,1,nil)
				if g:GetCount()>0 then
					if Duel.SendtoGrave(g,REASON_EFFECT)~=0 then
						Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(1111202,1))
						local g2=Duel.SelectMatchingCard(tp,c1111202.ofilter3x2,tp,LOCATION_GRAVE,0,1,1,nil)
						if g2:GetCount()>0 then
							local tc2=g2:GetFirst()
							Duel.MoveToField(tc2,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
						end
					end
				end
			end
		end
	end
end
--



