--超时空战斗机-Axelay
function c13257318.initial_effect(c)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(13257318,4))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c13257318.eqtg)
	e1:SetOperation(c13257318.eqop)
	c:RegisterEffect(e1)
	--atk/def
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetCondition(c13257318.adcon)
	e2:SetValue(c13257318.atkval)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	e3:SetCondition(c13257318.adcon)
	e3:SetValue(c13257318.defval)
	e3:SetLabelObject(e1)
	c:RegisterEffect(e3)
	--Power Capsule
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(13257318,0))
	e4:SetCategory(CATEGORY_TODECK)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,0x1e0)
	e4:SetTarget(c13257318.pctg)
	e4:SetOperation(c13257318.pcop)
	c:RegisterEffect(e4)
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e11:SetCode(EVENT_SUMMON_SUCCESS)
	e11:SetOperation(c13257318.bgmop)
	c:RegisterEffect(e11)
	c13257318[c]=e4
	
end
function c13257318.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=c:GetBattleTarget()
	if chk==0 then return c and Duel.GetAttacker()==c and tc and tc:IsControler(1-tp) and tc:IsAbleToChangeControler() and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	e:SetLabelObject(tc)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,tc,1,0,0)
end
function c13257318.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	if tc:IsRelateToBattle() and tc:IsType(TYPE_MONSTER) and tc:IsControler(1-tp) then
		if c:IsFaceup() and c:IsRelateToEffect(e) then
			if not Duel.Equip(tp,tc,c,false) then return end
			--Add Equip limit
			tc:RegisterFlagEffect(13257318,RESET_EVENT+0x1fe0000,0,0)
			e:SetLabelObject(tc)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetValue(c13257318.eqlimit)
			tc:RegisterEffect(e1)
			--substitute
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_EQUIP)
			e2:SetCode(EFFECT_DESTROY_SUBSTITUTE)
			e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			e2:SetValue(c13257318.repval)
			tc:RegisterEffect(e2)
		else Duel.SendtoGrave(tc,REASON_EFFECT) end
	end
end
function c13257318.eqlimit(e,c)
	return e:GetOwner()==c
end
function c13257318.repval(e,re,r,rp)
	return bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0
end
function c13257318.adcon(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetLabelObject():GetLabelObject()
	return ec and ec:GetFlagEffect(13257318)~=0
end
function c13257318.atkval(e,c)
	local ec=e:GetLabelObject():GetLabelObject()
	local atk=ec:GetTextAttack()
	if ec:IsFacedown() or bit.band(ec:GetOriginalType(),TYPE_MONSTER)==0 or atk<0 then
		return 0
	else
		return atk
	end
end
function c13257318.defval(e,c)
	local ec=e:GetLabelObject():GetLabelObject()
	local def=ec:GetTextDefense()
	if ec:IsFacedown() or bit.band(ec:GetOriginalType(),TYPE_MONSTER)==0 or def<0 then
		return 0
	else
		return def
	end
end
function c13257318.eqfilter(c,ec)
	return c:IsSetCard(0x3352) and c:IsType(TYPE_MONSTER) and c:CheckEquipTarget(ec)
end
function c13257318.pctg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local t1=c:GetEquipCount()>0 or Duel.IsExistingMatchingCard(c13257318.eqfilter,tp,LOCATION_EXTRA,0,1,nil,c)
	local t2=Duel.IsPlayerCanDraw(tp,1)
	if chk==0 then return (t1 or t2) and c:GetEquipCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,c:GetEquipGroup(),1,0,0)
end
function c13257318.pcop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local t1=c:GetEquipCount()>0 or Duel.IsExistingMatchingCard(c13257318.eqfilter,tp,LOCATION_EXTRA,0,1,nil,c) and c:IsRelateToEffect(e) and c:IsFaceup()
	local t2=Duel.IsPlayerCanDraw(tp,1)
	if not (t1 or t2) or c:GetEquipCount()==0 then return end
	local tg=c:GetEquipGroup():Select(tp,1,1,nil)
	if Duel.SendtoDeck(tg,nil,2,REASON_EFFECT)==0 then return end
	Duel.BreakEffect()
	local op=0
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(13257318,1))
	if t1 and t2 then
		op=Duel.SelectOption(tp,aux.Stringid(13257318,2),aux.Stringid(13257318,3))
	elseif t1 then
		op=Duel.SelectOption(tp,aux.Stringid(13257318,2))
	elseif t2 then
		op=Duel.SelectOption(tp,aux.Stringid(13257318,3))+1
	end
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=Duel.SelectMatchingCard(tp,c13257318.eqfilter,tp,LOCATION_EXTRA,0,1,1,nil,c)
		local tc=g:GetFirst()
		if tc then
			Duel.Equip(tp,tc,c)
		end
	elseif op==1 then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function c13257318.bgmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(11,0,aux.Stringid(13257318,7))
end
